package com.evan.sns.share;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.sina.weibo.sdk.api.ImageObject;
import com.sina.weibo.sdk.api.TextObject;
import com.sina.weibo.sdk.api.WeiboMultiMessage;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

public class ShareManager {
    private static class SingletonClassInstance{
        private static final ShareManager instance = new ShareManager();
    }

    private ShareManager(){}

    public static ShareManager getInstance(){
        return ShareManager.SingletonClassInstance.instance;
    }

    public void share(ShareEntity shareEntity, Activity activity, AsyncWorkHandler handler) {
        if (shareEntity.getType() == ShareEntity.ShareType.weChatSession
                || shareEntity.getType() == ShareEntity.ShareType.weChatTimeline) {
            this.shareWX(shareEntity, handler);
        } else if (shareEntity.getType() == ShareEntity.ShareType.weibo) {
            this.shareWb(shareEntity, activity, handler);
        }
    }

    private void shareWb(ShareEntity shareEntity, Activity activity, AsyncWorkHandler handler) {
        WeiboMultiMessage message = new WeiboMultiMessage();
        TextObject textObject = new TextObject();
//        textObject.title= shareEntity.getTitle();
        textObject.text = shareEntity.getTitle() + shareEntity.getWebPageUrl();
//        textObject.actionUrl = shareEntity.getWebPageUrl();

        message.textObject = textObject;

        ImageObject imageObject = new ImageObject();
        byte[] bytes = getThumb(shareEntity.getThumb());
        Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
        imageObject.setImageObject(bitmap);

        message.imageObject = imageObject;

        WeiboManager.getInstance().shareMessage(activity, message, handler);

    }

    private void shareWX(ShareEntity shareEntity, AsyncWorkHandler handler) {
        WXWebpageObject wxWebpage = new WXWebpageObject();
        //网页url
        wxWebpage.webpageUrl = shareEntity.getWebPageUrl();
        WXMediaMessage msg = new WXMediaMessage(wxWebpage);
        //网页标题
        msg.title = shareEntity.getTitle();

        //网页描述
        msg.description = shareEntity.getDesc();
        //缩略图
        msg.thumbData = getThumb(shareEntity.getThumb());

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("webpage");
        req.message = msg;
        req.scene = shareEntity.getType() == ShareEntity.ShareType.weChatSession ?
                    SendMessageToWX.Req.WXSceneSession : SendMessageToWX.Req.WXSceneTimeline;

        WXManager.getInstance().sendReq(req, handler);
    }

    /**
     * @param type
     * @return
     */
    private String buildTransaction(final String type) {
        return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
    }

    /**
     * @param url 缩略图
     * @return
     */
    private byte[] getThumb(final String url) {
        URL htmlUrl = null;
        InputStream inStream = null;
        try {
            htmlUrl = new URL(url);
            URLConnection connection = htmlUrl.openConnection();
            HttpURLConnection httpConnection = (HttpURLConnection)connection;
            int responseCode = httpConnection.getResponseCode();
            if(responseCode == HttpURLConnection.HTTP_OK){
                inStream = httpConnection.getInputStream();
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        byte[] data = inputStreamToByte(inStream);

        return data;
    }

    private byte[] inputStreamToByte(InputStream is) {
        try{
            ByteArrayOutputStream bytestream = new ByteArrayOutputStream();
            int ch;
            while ((ch = is.read()) != -1) {
                bytestream.write(ch);
            }
            byte imgdata[] = bytestream.toByteArray();
            bytestream.close();
            return imgdata;
        }catch(Exception e){
            e.printStackTrace();
        }

        return null;
    }
}

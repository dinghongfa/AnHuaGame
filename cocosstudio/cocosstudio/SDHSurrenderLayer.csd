<GameFile>
  <PropertyGroup Name="SDHSurrenderLayer" Type="Layer" ID="8d43cf63-dbcd-46f5-9b70-66cb51d95d45" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="637" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="Panel_mask" ActionTag="-648875981" Tag="638" IconVisible="False" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ComboBoxIndex="1" ColorAngle="90.0000" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Image_frame" ActionTag="1467695959" Tag="639" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="355.0000" RightMargin="355.0000" TopMargin="185.0000" BottomMargin="185.0000" LeftEage="205" RightEage="205" TopEage="125" BottomEage="125" Scale9OriginX="205" Scale9OriginY="125" Scale9Width="214" Scale9Height="130" ctype="ImageViewObjectData">
            <Size X="624.0000" Y="380.0000" />
            <Children>
              <AbstractNodeData Name="Text_title" ActionTag="-193571418" Tag="640" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="131.5000" RightMargin="131.5000" TopMargin="34.1265" BottomMargin="325.8735" FontSize="20" LabelText="庄家发起投降，15秒后将默认为同意(15)" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="361.0000" Y="20.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="312.0000" Y="335.8735" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.8839" />
                <PreSize X="0.5785" Y="0.0526" />
                <FontResource Type="Normal" Path="fonts/DFYuanW7-GB2312.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="ListView_surrend" ActionTag="-1527685698" Tag="641" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="112.0000" RightMargin="112.0000" TopMargin="77.1000" BottomMargin="122.9000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" ScrollDirectionType="0" ctype="ListViewObjectData">
                <Size X="400.0000" Y="180.0000" />
                <AnchorPoint ScaleX="0.5000" />
                <Position X="312.0000" Y="122.9000" />
                <Scale ScaleX="0.9869" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.3234" />
                <PreSize X="0.6410" Y="0.4737" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_agree" ActionTag="-5890160" Tag="647" IconVisible="False" LeftMargin="96.1024" RightMargin="374.8976" TopMargin="287.0507" BottomMargin="17.9493" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="123" Scale9Height="53" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="153.0000" Y="75.0000" />
                <Children>
                  <AbstractNodeData Name="Image_5" ActionTag="-483250084" Tag="649" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="38.0000" RightMargin="38.0000" TopMargin="18.0000" BottomMargin="18.0000" LeftEage="25" RightEage="25" TopEage="12" BottomEage="12" Scale9OriginX="25" Scale9OriginY="12" Scale9Width="27" Scale9Height="15" ctype="ImageViewObjectData">
                    <Size X="77.0000" Y="39.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="76.5000" Y="37.5000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.5033" Y="0.5200" />
                    <FileData Type="Normal" Path="sdh/ok_ui_sdh_agree.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="172.6024" Y="55.4493" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2766" Y="0.1459" />
                <PreSize X="0.2452" Y="0.1974" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="sdh/ok_ui_s_btn_yellow.png" Plist="" />
                <PressedFileData Type="Normal" Path="sdh/ok_ui_s_btn_yellow.png" Plist="" />
                <NormalFileData Type="Normal" Path="sdh/ok_ui_s_btn_yellow.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_disagree" ActionTag="429907158" Tag="648" IconVisible="False" LeftMargin="365.5575" RightMargin="105.4425" TopMargin="287.0507" BottomMargin="17.9493" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="123" Scale9Height="53" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="153.0000" Y="75.0000" />
                <Children>
                  <AbstractNodeData Name="Image_6" ActionTag="1171742682" Tag="650" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="20.5000" RightMargin="20.5000" TopMargin="17.5000" BottomMargin="17.5000" LeftEage="50" RightEage="50" TopEage="14" BottomEage="14" Scale9OriginX="50" Scale9OriginY="14" Scale9Width="12" Scale9Height="12" ctype="ImageViewObjectData">
                    <Size X="112.0000" Y="40.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="76.5000" Y="37.5000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.7320" Y="0.5333" />
                    <FileData Type="Normal" Path="sdh/ok_ui_sdh_refuse.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="442.0575" Y="55.4493" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7084" Y="0.1459" />
                <PreSize X="0.2452" Y="0.1974" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="sdh/ok_ui_s_btn_blue.png" Plist="" />
                <PressedFileData Type="Normal" Path="sdh/ok_ui_s_btn_blue.png" Plist="" />
                <NormalFileData Type="Normal" Path="sdh/ok_ui_s_btn_blue.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.4678" Y="0.5067" />
            <FileData Type="Normal" Path="sdh/ok_ui_sdh_vote_bg.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="Panel_item" ActionTag="2105698595" Tag="646" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-303.8352" RightMargin="1437.8352" TopMargin="276.4359" BottomMargin="293.5641" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" ctype="PanelObjectData">
            <Size X="200.0000" Y="180.0000" />
            <Children>
              <AbstractNodeData Name="Image_head" ActionTag="1999171194" Tag="642" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="50.0000" RightMargin="50.0000" TopMargin="7.6000" BottomMargin="72.4000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="34" Scale9Height="34" ctype="ImageViewObjectData">
                <Size X="100.0000" Y="100.0000" />
                <Children>
                  <AbstractNodeData Name="Image_3" ActionTag="717089448" Tag="643" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-5.0000" RightMargin="-5.0000" TopMargin="-5.0000" BottomMargin="-5.0000" LeftEage="36" RightEage="36" TopEage="36" BottomEage="36" Scale9OriginX="36" Scale9OriginY="36" Scale9Width="38" Scale9Height="38" ctype="ImageViewObjectData">
                    <Size X="110.0000" Y="110.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="50.0000" Y="50.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="1.1000" Y="1.1000" />
                    <FileData Type="Normal" Path="common/hall_avatarbg.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_name" ActionTag="-264885400" Tag="644" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="30.0000" RightMargin="30.0000" TopMargin="110.3401" BottomMargin="-30.3401" FontSize="20" LabelText="名字" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="40.0000" Y="20.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="50.0000" Y="-20.3401" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="-0.2034" />
                    <PreSize X="0.4000" Y="0.2000" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_flag" ActionTag="-329540107" Tag="645" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="14.5000" RightMargin="14.5000" TopMargin="137.0665" BottomMargin="-70.0665" LeftEage="23" RightEage="23" TopEage="10" BottomEage="10" Scale9OriginX="23" Scale9OriginY="10" Scale9Width="25" Scale9Height="13" ctype="ImageViewObjectData">
                    <Size X="71.0000" Y="33.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="50.0000" Y="-53.5665" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="-0.5357" />
                    <PreSize X="0.7100" Y="0.3300" />
                    <FileData Type="Normal" Path="sdh/ok_ui_sdh_vote_wait.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="100.0000" Y="122.4000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.6800" />
                <PreSize X="0.5000" Y="0.5556" />
                <FileData Type="Normal" Path="common/hall_avatar.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" />
            <Position X="-203.8352" Y="293.5641" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="-0.1528" Y="0.3914" />
            <PreSize X="0.1499" Y="0.2400" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>
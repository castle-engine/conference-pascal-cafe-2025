{ Main view, where most of the application logic takes place.

  Feel free to use this code as a starting point for your own projects.
  This template code is in public domain, unlike most other CGE code which
  is covered by BSD or LGPL (see https://castle-engine.io/license). }
unit GameViewMain;

interface

uses Classes,
  CastleVectors, CastleComponentSerialize, CastleViewport, CastleTransform,
  CastleUIControls, CastleControls, CastleKeysMouse, CastleCameras;

type
  { Main view, where most of the application logic takes place. }
  TViewMain = class(TCastleView)
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    LabelFps: TCastleLabel;
    Viewport1: TCastleViewport;
    WalkNavigation1: TCastleWalkNavigation;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure Update(const SecondsPassed: Single; var HandleInput: Boolean); override;
    function Press(const Event: TInputPressRelease): Boolean; override;
  end;

var
  ViewMain: TViewMain;

implementation

uses SysUtils;

{ TViewMain ----------------------------------------------------------------- }

constructor TViewMain.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewmain.castle-user-interface';
end;

procedure TViewMain.Start;
begin
  inherited;
end;

procedure TViewMain.Update(const SecondsPassed: Single; var HandleInput: Boolean);
begin
  inherited;
  { This virtual method is executed every frame (many times per second). }
  Assert(LabelFps <> nil, 'If you remove LabelFps from the design, remember to remove also the assignment "LabelFps.Caption := ..." from code');
  LabelFps.Caption := 'FPS: ' + Container.Fps.ToString;
end;

function TViewMain.Press(const Event: TInputPressRelease): Boolean;
var
  Transform: TCastleTransform;
  Pos, Dir, Up: TVector3;
begin
  Result := inherited;
  if Result then Exit; // allow the ancestor to handle keys

  if Event.IsKey(keyX) then
  begin
    Viewport1.Camera.GetWorldView(Pos, Dir, Up);
    
    Transform := TransformLoad('castle-data:/gamepad_with_physics.castle-transform', 
      FreeAtStop);
    Transform.Translation := Pos + Dir * 2;
    Transform.Direction := Dir;  
    Viewport1.Items.Add(Transform);
    
    Transform.RigidBody.ApplyImpulse(Dir * 0.01, Pos);
    
    Exit(true); // input was handled
  end;
  
  if Event.IsMouseButton(buttonRight) then
  begin
    WalkNavigation1.MouseLook := not WalkNavigation1.MouseLook;
    Exit(true); // input was handled
  end;
end;

end.

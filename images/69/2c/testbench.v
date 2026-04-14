`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] D2EXir;
    reg [31:0] EX2Mir;
    reg [31:0] F2Dir;
    reg [31:0] M2WBir;
    reg re1;
    reg re2;
    reg [4:0] rs;
    reg [4:0] rt;
    reg weex;
    reg wemem;
    reg wewb;
    reg [4:0] wsex;
    reg [4:0] wsmem;
    reg [4:0] wswb;
    wire [1:0] mux3sel;
    wire [1:0] mux4sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D2EXir(D2EXir),
        .EX2Mir(EX2Mir),
        .F2Dir(F2Dir),
        .M2WBir(M2WBir),
        .re1(re1),
        .re2(re2),
        .rs(rs),
        .rt(rt),
        .weex(weex),
        .wemem(wemem),
        .wewb(wewb),
        .wsex(wsex),
        .wsmem(wsmem),
        .wswb(wswb),
        .mux3sel(mux3sel),
        .mux4sel(mux4sel)
    );
    task reset_inputs;

    begin
        D2EXir = 0; EX2Mir = 0; F2Dir = 0; M2WBir = 0;
        re1 = 0; re2 = 0; rs = 0; rt = 0;
        weex = 0; wemem = 0; wewb = 0;
        wsex = 0; wsmem = 0; wswb = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_inputs();
        $display("Test %0d: Initial state / No hazards", test_num);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_inputs();
        rs = 5'd10; wsex = 5'd10; weex = 1; re1 = 1;
        $display("Test %0d: EX Hazard for rs (rs matches wsex)", test_num);
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_inputs();
        rs = 5'd15; wsmem = 5'd15; wemem = 1; re1 = 1;
        $display("Test %0d: MEM Hazard for rs (rs matches wsmem)", test_num);
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_inputs();
        rs = 5'd20; wswb = 5'd20; wewb = 1; re1 = 1;
        $display("Test %0d: WB Hazard for rs (rs matches wswb)", test_num);
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_inputs();
        rt = 5'd10; wsex = 5'd10; weex = 1; re2 = 1;
        $display("Test %0d: EX Hazard for rt (rt matches wsex)", test_num);
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_inputs();
        rt = 5'd15; wsmem = 5'd15; wemem = 1; re2 = 1;
        $display("Test %0d: MEM Hazard for rt (rt matches wsmem)", test_num);
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_inputs();
        rt = 5'd20; wswb = 5'd20; wewb = 1; re2 = 1;
        $display("Test %0d: WB Hazard for rt (rt matches wswb)", test_num);
        #1;

        check_outputs(2'b00, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_inputs();
        rs = 5'd5;
        wsex = 5'd5; weex = 1;
        wsmem = 5'd5; wemem = 1;
        wswb = 5'd5; wewb = 1;
        re1 = 1;
        $display("Test %0d: Priority check rs (EX > MEM > WB)", test_num);
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_inputs();
        rt = 5'd8;
        wsex = 5'd12; weex = 1;
        wsmem = 5'd8; wemem = 1;
        wswb = 5'd8; wewb = 1;
        re2 = 1;
        $display("Test %0d: Priority check rt (MEM > WB)", test_num);
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_inputs();
        rs = 5'd0; wsex = 5'd0; weex = 1; re1 = 1;
        $display("Test %0d: Register 0 check (No forwarding for R0)", test_num);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        reset_inputs();
        rs = 5'd5; wsex = 5'd5; weex = 1; re1 = 0;
        $display("Test %0d: Logic Gating (re1=0)", test_num);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        reset_inputs();
        rs = 5'd5; wsex = 5'd5; weex = 0; re1 = 1;
        $display("Test %0d: Logic Gating (weex=0)", test_num);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [1:0] expected_mux3sel;
        input [1:0] expected_mux4sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux3sel === (expected_mux3sel ^ mux3sel ^ expected_mux3sel) &&
                expected_mux4sel === (expected_mux4sel ^ mux4sel ^ expected_mux4sel)) begin
                $display("PASS");
                $display("  Outputs: mux3sel=%h, mux4sel=%h",
                         mux3sel, mux4sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux3sel=%h, mux4sel=%h",
                         expected_mux3sel, expected_mux4sel);
                $display("  Got:      mux3sel=%h, mux4sel=%h",
                         mux3sel, mux4sel);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule

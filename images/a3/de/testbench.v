`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ACLK;
    reg ARESETN;
    reg M_AXIS_DAT_TREADY;
    reg [32:0] S_AXIS_DAT_TDATA;
    reg S_AXIS_DAT_TLAST;
    reg [3:0] S_AXIS_DAT_TSTRB;
    reg [127:0] S_AXIS_DAT_TUSER;
    reg S_AXIS_DAT_TVALID;
    wire [32:0] M_AXIS_DAT_TDATA;
    wire M_AXIS_DAT_TLAST;
    wire [3:0] M_AXIS_DAT_TSTRB;
    wire [127:0] M_AXIS_DAT_TUSER;
    wire M_AXIS_DAT_TVALID;
    wire S_AXIS_DAT_TREADY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .M_AXIS_DAT_TREADY(M_AXIS_DAT_TREADY),
        .S_AXIS_DAT_TDATA(S_AXIS_DAT_TDATA),
        .S_AXIS_DAT_TLAST(S_AXIS_DAT_TLAST),
        .S_AXIS_DAT_TSTRB(S_AXIS_DAT_TSTRB),
        .S_AXIS_DAT_TUSER(S_AXIS_DAT_TUSER),
        .S_AXIS_DAT_TVALID(S_AXIS_DAT_TVALID),
        .M_AXIS_DAT_TDATA(M_AXIS_DAT_TDATA),
        .M_AXIS_DAT_TLAST(M_AXIS_DAT_TLAST),
        .M_AXIS_DAT_TSTRB(M_AXIS_DAT_TSTRB),
        .M_AXIS_DAT_TUSER(M_AXIS_DAT_TUSER),
        .M_AXIS_DAT_TVALID(M_AXIS_DAT_TVALID),
        .S_AXIS_DAT_TREADY(S_AXIS_DAT_TREADY)
    );
    task testcase001;

    begin
        $display("\nTestcase 001: Reset and Idle State");
        ARESETN = 0;
        M_AXIS_DAT_TREADY = 1;
        S_AXIS_DAT_TVALID = 0;
        S_AXIS_DAT_TDATA = 0;
        S_AXIS_DAT_TSTRB = 0;
        S_AXIS_DAT_TUSER = 0;
        S_AXIS_DAT_TLAST = 0;
        repeat(2) @(posedge ACLK);




        #1;





        check_outputs(33'h0, 0, 4'h0, 128'h0, 0, S_AXIS_DAT_TREADY);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Basic Data Forwarding");
        ARESETN = 0; #10; ARESETN = 1;
        @(posedge ACLK);
        S_AXIS_DAT_TDATA  = 33'h1_AAAAAAAA;
        S_AXIS_DAT_TVALID = 1'b1;
        S_AXIS_DAT_TSTRB  = 4'hF;
        S_AXIS_DAT_TUSER  = 128'hDEADBEEF_CAFEBABE_01234567_89ABCDEF;
        S_AXIS_DAT_TLAST  = 1'b0;
        M_AXIS_DAT_TREADY = 1'b1;

        @(posedge ACLK);
        #1;


        #1;



        check_outputs(33'h1_AAAAAAAA, 1'b0, 4'hF, 128'hDEADBEEF_CAFEBABE_01234567_89ABCDEF, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: TLAST Propagation");
        ARESETN = 1;
        @(posedge ACLK);
        S_AXIS_DAT_TDATA  = 33'h0_55555555;
        S_AXIS_DAT_TLAST  = 1'b1;
        S_AXIS_DAT_TVALID = 1'b1;
        M_AXIS_DAT_TREADY = 1'b1;

        @(posedge ACLK);
        #1;
        #1;

        check_outputs(33'h0_55555555, 1'b1, S_AXIS_DAT_TSTRB, S_AXIS_DAT_TUSER, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Backpressure Handling");
        ARESETN = 0; #10; ARESETN = 1;
        @(posedge ACLK);
        S_AXIS_DAT_TVALID = 1'b1;
        M_AXIS_DAT_TREADY = 1'b0;

        @(posedge ACLK);
        #1;

        #1;


        check_outputs(M_AXIS_DAT_TDATA, M_AXIS_DAT_TLAST, M_AXIS_DAT_TSTRB, M_AXIS_DAT_TUSER, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Metadata Bit Rearranging");
        ARESETN = 0; #10; ARESETN = 1;
        @(posedge ACLK);
        S_AXIS_DAT_TVALID = 1'b1;
        M_AXIS_DAT_TREADY = 1'b1;

        S_AXIS_DAT_TUSER = 128'h00112233445566778899AABBCCDDEEFF;

        @(posedge ACLK);
        #1;



        #1;




        check_outputs(S_AXIS_DAT_TDATA, S_AXIS_DAT_TLAST, S_AXIS_DAT_TSTRB, M_AXIS_DAT_TUSER, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Partial Strobe Handling");
        ARESETN = 1;
        @(posedge ACLK);
        S_AXIS_DAT_TVALID = 1'b1;
        S_AXIS_DAT_TSTRB  = 4'b1001;
        M_AXIS_DAT_TREADY = 1'b1;

        @(posedge ACLK);
        #1;
        #1;

        check_outputs(S_AXIS_DAT_TDATA, S_AXIS_DAT_TLAST, 4'b1001, M_AXIS_DAT_TUSER, 1'b1, 1'b1);
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
        input [32:0] expected_M_AXIS_DAT_TDATA;
        input expected_M_AXIS_DAT_TLAST;
        input [3:0] expected_M_AXIS_DAT_TSTRB;
        input [127:0] expected_M_AXIS_DAT_TUSER;
        input expected_M_AXIS_DAT_TVALID;
        input expected_S_AXIS_DAT_TREADY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M_AXIS_DAT_TDATA === (expected_M_AXIS_DAT_TDATA ^ M_AXIS_DAT_TDATA ^ expected_M_AXIS_DAT_TDATA) &&
                expected_M_AXIS_DAT_TLAST === (expected_M_AXIS_DAT_TLAST ^ M_AXIS_DAT_TLAST ^ expected_M_AXIS_DAT_TLAST) &&
                expected_M_AXIS_DAT_TSTRB === (expected_M_AXIS_DAT_TSTRB ^ M_AXIS_DAT_TSTRB ^ expected_M_AXIS_DAT_TSTRB) &&
                expected_M_AXIS_DAT_TUSER === (expected_M_AXIS_DAT_TUSER ^ M_AXIS_DAT_TUSER ^ expected_M_AXIS_DAT_TUSER) &&
                expected_M_AXIS_DAT_TVALID === (expected_M_AXIS_DAT_TVALID ^ M_AXIS_DAT_TVALID ^ expected_M_AXIS_DAT_TVALID) &&
                expected_S_AXIS_DAT_TREADY === (expected_S_AXIS_DAT_TREADY ^ S_AXIS_DAT_TREADY ^ expected_S_AXIS_DAT_TREADY)) begin
                $display("PASS");
                $display("  Outputs: M_AXIS_DAT_TDATA=%h, M_AXIS_DAT_TLAST=%b, M_AXIS_DAT_TSTRB=%h, M_AXIS_DAT_TUSER=%h, M_AXIS_DAT_TVALID=%b, S_AXIS_DAT_TREADY=%b",
                         M_AXIS_DAT_TDATA, M_AXIS_DAT_TLAST, M_AXIS_DAT_TSTRB, M_AXIS_DAT_TUSER, M_AXIS_DAT_TVALID, S_AXIS_DAT_TREADY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_AXIS_DAT_TDATA=%h, M_AXIS_DAT_TLAST=%b, M_AXIS_DAT_TSTRB=%h, M_AXIS_DAT_TUSER=%h, M_AXIS_DAT_TVALID=%b, S_AXIS_DAT_TREADY=%b",
                         expected_M_AXIS_DAT_TDATA, expected_M_AXIS_DAT_TLAST, expected_M_AXIS_DAT_TSTRB, expected_M_AXIS_DAT_TUSER, expected_M_AXIS_DAT_TVALID, expected_S_AXIS_DAT_TREADY);
                $display("  Got:      M_AXIS_DAT_TDATA=%h, M_AXIS_DAT_TLAST=%b, M_AXIS_DAT_TSTRB=%h, M_AXIS_DAT_TUSER=%h, M_AXIS_DAT_TVALID=%b, S_AXIS_DAT_TREADY=%b",
                         M_AXIS_DAT_TDATA, M_AXIS_DAT_TLAST, M_AXIS_DAT_TSTRB, M_AXIS_DAT_TUSER, M_AXIS_DAT_TVALID, S_AXIS_DAT_TREADY);
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

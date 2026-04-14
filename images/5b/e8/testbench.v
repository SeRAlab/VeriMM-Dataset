`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [1023:0] idata;
    reg [4:0] raddr;
    wire [31:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .idata(idata),
        .raddr(raddr),
        .rdata(rdata)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select Segment 0", test_num);
        idata = 1024'h0;
        idata[31:0] = 32'hDEADBEEF;
        raddr = 5'd0;
        @(posedge clk);
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select Segment 31", test_num);
        idata = 1024'h0;
        idata[1023:992] = 32'hCAFEBABE;
        raddr = 5'd31;
        @(posedge clk);
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select Segment 1", test_num);
        idata = 1024'h0;
        idata[63:32] = 32'h12345678;
        raddr = 5'd1;
        @(posedge clk);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Select Segment 15", test_num);
        idata = 1024'h0;
        idata[15*32 +: 32] = 32'hAAAA_5555;
        raddr = 5'd15;
        @(posedge clk);
        #1;

        check_outputs(32'hAAAA_5555);
    end
        endtask

    task testcase005;

        integer i;
    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Full Data Load - Select Segment 10", test_num);
        for (i = 0; i < 32; i = i + 1) begin
            idata[i*32 +: 32] = i;
        end
        raddr = 5'd10;
        @(posedge clk);
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Dynamic Address Change (Segment 20)", test_num);

        raddr = 5'd20;
        @(posedge clk);
        #1;

        check_outputs(32'd20);
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
        input [31:0] expected_rdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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

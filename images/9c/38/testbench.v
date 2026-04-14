`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] addr;
    reg clk_sys;
    reg [7:0] idata;
    reg reset;
    reg we_n;
    wire [7:0] odata;
    wire [7:0] opa;
    wire [7:0] opb;
    wire [7:0] opc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk_sys(clk_sys),
        .idata(idata),
        .reset(reset),
        .we_n(we_n),
        .odata(odata),
        .opa(opa),
        .opb(opb),
        .opc(opc)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: System Reset - Verifying initial states", test_num);


        reset = 1;
        addr = 2'b00;
        idata = 8'h00;
        we_n = 1;
        @(posedge clk_sys);
        #2 reset = 0;
        @(posedge clk_sys);


        #1;



        check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write to Port A (Address 00)", test_num);

        reset = 1; #10 reset = 0;
        @(posedge clk_sys);


        addr = 2'b00;
        idata = 8'hAA;
        we_n = 0;
        @(posedge clk_sys);
        #2 we_n = 1;


        #1;



        check_outputs(8'hAA, 8'hAA, 8'h00, 8'h00);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write to Port B (Address 01)", test_num);

        reset = 1; #10 reset = 0;
        @(posedge clk_sys);


        addr = 2'b01;
        idata = 8'h55;
        we_n = 0;
        @(posedge clk_sys);
        #2 we_n = 1;


        #1;



        check_outputs(8'h55, 8'h00, 8'h55, 8'h00);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write to Port C (Address 10)", test_num);

        reset = 1; #10 reset = 0;
        @(posedge clk_sys);


        addr = 2'b10;
        idata = 8'hF0;
        we_n = 0;
        @(posedge clk_sys);
        #2 we_n = 1;


        #1;



        check_outputs(8'hF0, 8'h00, 8'h00, 8'hF0);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multi-Port Write Sequence", test_num);

        reset = 1; #10 reset = 0;
        @(posedge clk_sys);


        addr = 2'b00; idata = 8'h12; we_n = 0;
        @(posedge clk_sys); #2;

        addr = 2'b01; idata = 8'h34; we_n = 0;
        @(posedge clk_sys); #2;

        addr = 2'b10; idata = 8'h56; we_n = 0;
        @(posedge clk_sys); #2;


        we_n = 1;
        addr = 2'b00;


        #1;



        check_outputs(8'h12, 8'h12, 8'h34, 8'h56);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write Control Word and Reset Behavior", test_num);

        reset = 1; #10 reset = 0;
        @(posedge clk_sys);


        addr = 2'b00; idata = 8'hFF; we_n = 0;
        @(posedge clk_sys); #2;


        reset = 1;
        @(posedge clk_sys);
        #2 reset = 0;


        addr = 2'b00; we_n = 1;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_odata;
        input [7:0] expected_opa;
        input [7:0] expected_opb;
        input [7:0] expected_opc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_odata === (expected_odata ^ odata ^ expected_odata) &&
                expected_opa === (expected_opa ^ opa ^ expected_opa) &&
                expected_opb === (expected_opb ^ opb ^ expected_opb) &&
                expected_opc === (expected_opc ^ opc ^ expected_opc)) begin
                $display("PASS");
                $display("  Outputs: odata=%h, opa=%h, opb=%h, opc=%h",
                         odata, opa, opb, opc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: odata=%h, opa=%h, opb=%h, opc=%h",
                         expected_odata, expected_opa, expected_opb, expected_opc);
                $display("  Got:      odata=%h, opa=%h, opb=%h, opc=%h",
                         odata, opa, opb, opc);
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

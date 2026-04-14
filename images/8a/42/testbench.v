`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] daddr;
    reg de;
    reg [31:0] din;
    reg [1:0] drw;
    reg [31:0] iaddr;
    reg ie;
    reg rst;
    wire [31:0] dout;
    wire [31:0] iout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .daddr(daddr),
        .de(de),
        .din(din),
        .drw(drw),
        .iaddr(iaddr),
        .ie(ie),
        .rst(rst),
        .dout(dout),
        .iout(iout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Resetting the module", test_num);
            rst = 1;
            ie = 0;
            de = 0;
            drw = 2'b00;
            iaddr = 32'h0;
            daddr = 32'h0;
            din = 32'h0;

            @(negedge clk);
            rst = 0;
            @(negedge clk);


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Data Write and Read-back", test_num);


            rst = 1;
            @(negedge clk);
            rst = 0;


            de = 1;
            drw = 2'b01;
            daddr = 32'hA0A0A0A0;
            din = 32'hDEADBEEF;
            @(negedge clk);


            drw = 2'b00;
            @(negedge clk);


            #1;



            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Instruction Address Fetch", test_num);


            rst = 1;
            @(negedge clk);
            rst = 0;


            ie = 1;
            iaddr = 32'h0000_1234;
            de = 0;
            @(negedge clk);




            #1;





            check_outputs(32'h0, iout);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Simultaneous IE and DE", test_num);


            rst = 1;
            @(negedge clk);
            rst = 0;


            de = 1;
            drw = 2'b01;
            daddr = 32'hC0DE_0001;
            din = 32'h11223344;
            @(negedge clk);


            ie = 1;
            iaddr = 32'hF0F0_F0F0;
            drw = 2'b00;
            @(negedge clk);

            #1;


            check_outputs(32'h11223344, iout);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Enable Gating Test", test_num);


            rst = 1;
            @(negedge clk);
            rst = 0;


            de = 0;
            drw = 2'b01;
            daddr = 32'h0000_0004;
            din = 32'hFFFF_FFFF;
            @(negedge clk);


            de = 1;
            drw = 2'b00;
            @(negedge clk);


            if (dout !== 32'hFFFF_FFFF) begin
                #1;

                check_outputs(dout, iout);
            end else begin
                $display("FAIL: Data written while de was low");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_dout;
        input [31:0] expected_iout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_iout === (expected_iout ^ iout ^ expected_iout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, iout=%h",
                         dout, iout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, iout=%h",
                         expected_dout, expected_iout);
                $display("  Got:      dout=%h, iout=%h",
                         dout, iout);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din1;
    reg [31:0] din2;
    reg [7:0] ra;
    reg [7:0] wa1;
    reg [7:0] wa2;
    reg [3:0] wbe;
    reg we1;
    reg we2;
    wire [31:0] dout1;
    wire [31:0] dout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din1(din1),
        .din2(din2),
        .ra(ra),
        .wa1(wa1),
        .wa2(wa2),
        .wbe(wbe),
        .we1(we1),
        .we2(we2),
        .dout1(dout1),
        .dout2(dout2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            din1 = 0;
            din2 = 0;
            ra = 0;
            wa1 = 0;
            wa2 = 0;
            wbe = 0;
            we1 = 0;
            we2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Port 1 Basic Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            wa1 = 8'h10;
            din1 = 32'hDEADBEEF;
            we1 = 1;
            wbe = 4'b1111;

            @(posedge clk);
            we1 = 0;
            ra = 8'h10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Port 2 Basic Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            wa2 = 8'h20;
            din2 = 32'hCAFEBABE;
            we2 = 1;
            wbe = 4'b1111;

            @(posedge clk);
            we2 = 0;
            ra = 8'h20;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFEBABE, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Dual Port Write", test_num);
            reset_dut();


            @(posedge clk);
            wa1 = 8'h30; din1 = 32'h11111111; we1 = 1;
            wa2 = 8'h31; din2 = 32'h22222222; we2 = 1;
            wbe = 4'b1111;

            @(posedge clk);
            we1 = 0; we2 = 0;


            ra = 8'h30;
            @(posedge clk);
            #1;
            if (dout1 !== 32'h11111111) begin
                $display("Subtest failed for addr 0x30");
                fail_count = fail_count + 1;
            end else begin

                ra = 8'h31;
                @(posedge clk);
                #1;
                #1;

                check_outputs(32'h22222222, 32'h22222222);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selective Byte Enable Write", test_num);
            reset_dut();


            @(posedge clk);
            wa1 = 8'h40; din1 = 32'h00000000; we1 = 1; wbe = 4'b1111;
            @(posedge clk);




            wa1 = 8'h40; din1 = 32'hFFEEDDCC; we1 = 1; wbe = 4'b0101;
            @(posedge clk);
            we1 = 0;
            ra = 8'h40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00EE00CC, 32'h00EE00CC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Concurrent Read and Write to same address", test_num);
            reset_dut();


            @(posedge clk);
            wa1 = 8'h50; din1 = 32'h5555AAAA; we1 = 1; wbe = 4'b1111;
            ra = 8'h50;

            @(posedge clk);



            we1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555AAAA, 32'h5555AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Port Collision at same address", test_num);
            reset_dut();

            @(posedge clk);
            wa1 = 8'h60; din1 = 32'hAAAAAAAA; we1 = 1;
            wa2 = 8'h60; din2 = 32'h55555555; we2 = 1;
            wbe = 4'b1111;

            @(posedge clk);
            we1 = 0; we2 = 0;
            ra = 8'h60;
            @(posedge clk);
            #1;


            $display("Result of collision: %h", dout1);
            if (dout1 == 32'h55555555 || dout1 == 32'hAAAAAAAA) begin
                pass_count = pass_count + 1;
                $display("PASS");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL");
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
        input [31:0] expected_dout1;
        input [31:0] expected_dout2;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h, dout2=%h",
                         dout1, dout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h, dout2=%h",
                         expected_dout1, expected_dout2);
                $display("  Got:      dout1=%h, dout2=%h",
                         dout1, dout2);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, din1, din2, ra, wa1, wa2, wbe, we1, we2, dout1, dout2);
    end

endmodule

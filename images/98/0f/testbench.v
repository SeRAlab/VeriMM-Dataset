`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg [3:0] be;
    reg clk;
    reg [31:0] din;
    reg we;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .be(be),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 10'd0;
            be = 4'b0000;
            din = 32'd0;
            we = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Full Word Write", test_num);
            addr = 10'h0A5;
            din = 32'hDEADBEEF;
            be = 4'b1111;
            we = 1'b1;
            @(posedge clk);
            #1;
            we = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Partial Byte Write (Lower 16 bits)", test_num);


            addr = 10'h010;
            din = 32'hFFFFFFFF;
            be = 4'b1111;
            we = 1'b1;
            @(posedge clk);
            #1;


            din = 32'hABCD1234;
            be = 4'b0011;
            @(posedge clk);
            #1;

            we = 1'b0;

            #1;


            check_outputs(32'hFFFF1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Partial Byte Write (Upper 16 bits)", test_num);


            addr = 10'h020;
            din = 32'h00000000;
            be = 4'b1111;
            we = 1'b1;
            @(posedge clk);
            #1;


            din = 32'hAAAA5555;
            be = 4'b1100;
            @(posedge clk);
            #1;

            we = 1'b0;

            #1;


            check_outputs(32'hAAAA0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Write Enable Validation", test_num);


            addr = 10'h050;
            din = 32'h11223344;
            be = 4'b1111;
            we = 1'b1;
            @(posedge clk);
            #1;


            din = 32'h99887766;
            we = 1'b0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h11223344);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Asynchronous Read Check", test_num);


            addr = 10'h005;
            din = 32'hAAAAAAAA;
            be = 4'b1111;
            we = 1'b1;
            @(posedge clk);
            #1;


            addr = 10'h006;
            din = 32'hBBBBBBBB;
            @(posedge clk);
            #1;

            we = 1'b0;

            addr = 10'h005;
            #1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Boundary Address (1023)", test_num);

            addr = 10'd1023;
            din = 32'h55AA55AA;
            be = 4'b1111;
            we = 1'b1;
            @(posedge clk);
            #1;

            we = 1'b0;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Single Byte Enable (Byte 2)", test_num);

            addr = 10'h100;
            din = 32'h00000000;
            be = 4'b1111;
            we = 1'b1;
            @(posedge clk);
            #1;

            din = 32'h00FF0000;
            be = 4'b0100;
            @(posedge clk);
            #1;

            we = 1'b0;
            #1;

            check_outputs(32'h00FF0000);
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
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, be, clk, din, we, dout);
    end

endmodule

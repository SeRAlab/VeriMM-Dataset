`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [16:0] data_a;
    reg [16:0] data_b;
    reg [15:0] ddata_in;
    wire [33:0] data_p;
    wire [15:0] ddata_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .ddata_in(ddata_in),
        .data_p(data_p),
        .ddata_out(ddata_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_a = 0;
            data_b = 0;
            ddata_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic small value multiplication", test_num);
            reset_dut();
            data_a <= 17'd12;
            data_b <= 17'd10;
            ddata_in <= 16'h1234;


            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(34'd120, 16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 17-bit value multiplication", test_num);
            reset_dut();

            data_a <= 17'h1FFFF;
            data_b <= 17'h1FFFF;
            ddata_in <= 16'hFFFF;

            repeat(3) @(posedge clk);
            #2;


            #1;



            check_outputs(34'h3FFFC0001, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by zero", test_num);
            reset_dut();
            data_a <= 17'h15555;
            data_b <= 17'h00000;
            ddata_in <= 16'hCAFE;

            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(34'd0, 16'hCAFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by one", test_num);
            reset_dut();
            data_a <= 17'h0AAAA;
            data_b <= 17'd1;
            ddata_in <= 16'h5555;

            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs({17'd0, 17'h0AAAA}, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of two multiplication", test_num);
            reset_dut();
            data_a <= 17'd256;
            data_b <= 17'd512;
            ddata_in <= 16'hABCD;

            repeat(3) @(posedge clk);
            #2;


            #1;



            check_outputs(34'h20000, 16'hABCD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime number multiplication", test_num);
            reset_dut();
            data_a <= 17'd97;
            data_b <= 17'd89;
            ddata_in <= 16'hC0DE;

            repeat(3) @(posedge clk);
            #2;


            #1;



            check_outputs(34'd8633, 16'hC0DE);
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
        input [33:0] expected_data_p;
        input [15:0] expected_ddata_out;
        begin
            if (expected_data_p === (expected_data_p ^ data_p ^ expected_data_p) &&
                expected_ddata_out === (expected_ddata_out ^ ddata_out ^ expected_ddata_out)) begin
                $display("PASS");
                $display("  Outputs: data_p=%h, ddata_out=%h",
                         data_p, ddata_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_p=%h, ddata_out=%h",
                         expected_data_p, expected_ddata_out);
                $display("  Got:      data_p=%h, ddata_out=%h",
                         data_p, ddata_out);
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
        $dumpvars(0,clk, data_a, data_b, ddata_in, data_p, ddata_out);
    end

endmodule

`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] in_bits;
    wire [1:0] out_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .in_bits(in_bits),
        .out_bits(out_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_bits = 2'b00;

            repeat (4) @(posedge clk);
            $display("DUT Reset sequence completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All-Zeros Input Stream", test_num);
            reset_dut();

            @(posedge clk) in_bits = 2'b00;
            @(posedge clk) in_bits = 2'b00;
            @(posedge clk) in_bits = 2'b00;
            @(posedge clk) in_bits = 2'b00;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High State Transition", test_num);
            reset_dut();

            @(posedge clk) in_bits = 2'b11;
            @(posedge clk) in_bits = 2'b11;
            @(posedge clk) in_bits = 2'b11;
            @(posedge clk) in_bits = 2'b11;



            #1;




            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Error Correction (Single Bit)", test_num);
            reset_dut();

            @(posedge clk) in_bits = 2'b00;
            @(posedge clk) in_bits = 2'b01;
            @(posedge clk) in_bits = 2'b00;
            @(posedge clk) in_bits = 2'b00;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Data Pattern", test_num);
            reset_dut();

            @(posedge clk) in_bits = 2'b11;
            @(posedge clk) in_bits = 2'b10;
            @(posedge clk) in_bits = 2'b00;
            @(posedge clk) in_bits = 2'b11;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-Noise Burst Correction", test_num);
            reset_dut();

            @(posedge clk) in_bits = 2'b11;
            @(posedge clk) in_bits = 2'b00;
            @(posedge clk) in_bits = 2'b11;
            @(posedge clk) in_bits = 2'b11;


            #1;



            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input [1:0] expected_out_bits;
        begin
            if (expected_out_bits === (expected_out_bits ^ out_bits ^ expected_out_bits)) begin
                $display("PASS");
                $display("  Outputs: out_bits=%h",
                         out_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_bits=%h",
                         expected_out_bits);
                $display("  Got:      out_bits=%h",
                         out_bits);
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
        $dumpvars(0,clk, in_bits, out_bits);
    end

endmodule

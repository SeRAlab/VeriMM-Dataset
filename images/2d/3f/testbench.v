`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire [3:0] codeword_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .codeword_out(codeword_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset then Input 0...", test_num);
            reset_dut();
            data_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset then Input 1...", test_num);
            reset_dut();
            data_in = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'hD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1 then 0...", test_num);
            reset_dut();
            data_in = 1;
            @(posedge clk);
            #1;
            data_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1 then 1...", test_num);
            reset_dut();
            data_in = 1;
            @(posedge clk);
            #1;
            data_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1 -> 0 -> 1...", test_num);
            reset_dut();
            data_in = 1; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Recovery with data_in=1...", test_num);
            reset = 1;
            data_in = 1;
            @(posedge clk);
            #1;
            reset = 0;
            data_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
        input [3:0] expected_codeword_out;
        begin
            if (expected_codeword_out === (expected_codeword_out ^ codeword_out ^ expected_codeword_out)) begin
                $display("PASS");
                $display("  Outputs: codeword_out=%h",
                         codeword_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword_out=%h",
                         expected_codeword_out);
                $display("  Got:      codeword_out=%h",
                         codeword_out);
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
        $dumpvars(0,clk, data_in, reset, codeword_out);
    end

endmodule

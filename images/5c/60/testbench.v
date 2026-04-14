`timescale 1ns/1ps

module johnson_counter_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter_8bit dut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset and Initial State...");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: One clock cycle after reset...");
            reset_dut();
            @(negedge clk);

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Four clock cycles after reset...");
            reset_dut();
            repeat(4) @(negedge clk);

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Eight clock cycles after reset...");
            reset_dut();
            repeat(8) @(negedge clk);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Twelve clock cycles after reset...");
            reset_dut();
            repeat(12) @(negedge clk);





            #1;






            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Full sequence (16 cycles) wrap-around...");
            reset_dut();
            repeat(16) @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Reset triggered mid-operation...");
            reset_dut();
            repeat(5) @(negedge clk);
            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Checking 15th state...");
            reset_dut();
            repeat(15) @(negedge clk);




            #1;





            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset, q);
    end

endmodule

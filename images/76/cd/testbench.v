`timescale 1ns/1ps

module shift_register_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] parallel_in;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_4bit dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            parallel_in <= 4'b0000;
            @(posedge clk);
            load <= 0;
            parallel_in <= 4'b0000;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Parallel Load 4'b1010", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            parallel_in <= 4'b1010;
            @(posedge clk);
            load <= 0;

            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Left Shift (0001 -> 0010)", test_num);
            reset_dut();


            @(posedge clk);
            load <= 1;
            parallel_in <= 4'b0001;
            @(posedge clk);
            load <= 0;


            @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Left Shifts (0011 -> 1100)", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            parallel_in <= 4'b0011;
            @(posedge clk);
            load <= 0;


            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Shift out MSB (1000 -> 0000)", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            parallel_in <= 4'b1000;
            @(posedge clk);
            load <= 0;

            @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load Priority Over Shift", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            parallel_in <= 4'b1111;

            @(posedge clk);

            parallel_in <= 4'b0101;

            @(posedge clk);
            load <= 0;

            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Full Clear via Shifting", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            parallel_in <= 4'b1111;
            @(posedge clk);
            load <= 0;

            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_4bit Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, load, parallel_in, q);
    end

endmodule

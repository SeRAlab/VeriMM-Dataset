`timescale 1ns/1ps

module up_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg ld;
    reg [2:0] load_value;
    reg rst_n;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter_3bit dut (
        .clk(clk),
        .en(en),
        .ld(ld),
        .load_value(load_value),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            ld = 0;
            load_value = 3'b000;
            @(negedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Incrementing from 0 to 4", test_num);
            reset_dut();
            en = 1;
            ld = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Loading value 3'b110 (6)", test_num);
            reset_dut();
            ld = 1;
            en = 0;
            load_value = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Load priority over Enable (Load 2 while En is high)", test_num);
            reset_dut();
            ld = 1;
            en = 1;
            load_value = 3'b010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Counter wrap-around from 7 to 0", test_num);
            reset_dut();

            ld = 1;
            load_value = 3'b111;
            @(posedge clk);
            #1;

            ld = 0;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Counter hold when Enable is low", test_num);
            reset_dut();

            ld = 1;
            load_value = 3'b101;
            @(posedge clk);
            #1;

            ld = 0;
            en = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Complex sequence (Load -> Count -> Count)", test_num);
            reset_dut();

            ld = 1;
            load_value = 3'b001;
            @(posedge clk);
            #1;

            ld = 0;
            en = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter_3bit Testbench");
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
        input [2:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, ld, load_value, rst_n, count);
    end

endmodule

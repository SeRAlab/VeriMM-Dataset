`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [3:0] johnson_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .johnson_code(johnson_code)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            en = 0;
            @(negedge clk);
            rst = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying First Step (1000)", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying Step 4 (1111)", test_num);
            reset_dut();
            en = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying Full Cycle (Return to 0000)", test_num);
            reset_dut();
            en = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying Enable Signal Pause/Resume", test_num);
            reset_dut();


            en = 1;
            repeat(2) @(posedge clk);


            en = 0;
            repeat(2) @(posedge clk);


            en = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying Step 6 (0011)", test_num);
            reset_dut();
            en = 1;
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
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
        input [3:0] expected_johnson_code;
        begin
            if (expected_johnson_code === (expected_johnson_code ^ johnson_code ^ expected_johnson_code)) begin
                $display("PASS");
                $display("  Outputs: johnson_code=%h",
                         johnson_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: johnson_code=%h",
                         expected_johnson_code);
                $display("  Got:      johnson_code=%h",
                         johnson_code);
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
        $dumpvars(0,clk, en, rst, johnson_code);
    end

endmodule

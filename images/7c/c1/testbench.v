`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg en;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .areset(areset),
        .clk(clk),
        .en(en),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            en = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking reset state", test_num);
            reset_dut();
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Advance 1 step", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            @(posedge clk);
            en = 0;
            #1;
            #1;

            check_outputs(6'b100000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Advance 6 steps to 111111", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for(i=0; i<6; i=i+1) @(posedge clk);
            en = 0;
            #1;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Advance 11 steps", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for(i=0; i<11; i=i+1) @(posedge clk);
            en = 0;
            #1;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Full cycle wrap-around (12 steps)", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for(i=0; i<12; i=i+1) @(posedge clk);
            en = 0;
            #1;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Counter hold when enable is low", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for(i=0; i<3; i=i+1) @(posedge clk);
            en = 0;
            for(i=0; i<3; i=i+1) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b111000);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %03d: Asynchronous reset mid-count", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for(i=0; i<5; i=i+1) @(posedge clk);
            #3;
            areset = 1;
            #2;
            #1;

            check_outputs(6'b000000);
            areset = 0;
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
        input [5:0] expected_count;
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
        $dumpvars(0,areset, clk, en, count);
    end

endmodule

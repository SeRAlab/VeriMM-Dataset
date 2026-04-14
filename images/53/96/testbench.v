`timescale 1ns/1ps

module washing_machine_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg start_wash;
    reg wash_done;
    wire washing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    washing_machine_controller dut (
        .areset(areset),
        .clk(clk),
        .start_wash(start_wash),
        .wash_done(wash_done),
        .washing(washing)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        start_wash = 0;
        wash_done = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        start_wash <= 1;
        @(posedge clk);
        start_wash <= 0;
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        @(posedge clk);
        start_wash <= 1;
        @(posedge clk);
        start_wash <= 0;

        @(posedge clk);
        wash_done <= 1;
        @(posedge clk);
        wash_done <= 0;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(posedge clk);
        start_wash <= 1;
        @(posedge clk);
        start_wash <= 0;

        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        @(posedge clk);
        start_wash <= 1;
        @(posedge clk);
        start_wash <= 0;
        #2;

        areset = 1;
        #1;
        #1;

        check_outputs(1'b0);
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
        $display("washing_machine_controller Testbench");
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
        input expected_washing;
        begin
            if (expected_washing === (expected_washing ^ washing ^ expected_washing)) begin
                $display("PASS");
                $display("  Outputs: washing=%b",
                         washing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: washing=%b",
                         expected_washing);
                $display("  Got:      washing=%b",
                         washing);
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
        $dumpvars(0,areset, clk, start_wash, wash_done, washing);
    end

endmodule

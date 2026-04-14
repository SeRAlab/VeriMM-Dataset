`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg mosi;
    wire miso;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .mosi(mosi),
        .miso(miso),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        cs = 1;
        mosi = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Idle State Check", test_num);
        cs = 1;
        mosi = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(miso, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Transmitting logic 1", test_num);
        cs = 0;
        mosi = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Transmitting logic 0", test_num);
        cs = 0;
        mosi = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Multi-bit Sequence (101)", test_num);
        cs = 0;

        mosi = 1; @(posedge clk);
        mosi = 0; @(posedge clk);
        mosi = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Terminating Transmission via CS", test_num);
        cs = 0;
        mosi = 1;
        @(posedge clk);
        #1;
        cs = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(miso, 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Check synchronous MOSI sampling", test_num);
        cs = 0;
        mosi = 0;
        @(posedge clk);
        #1;
        mosi = 1;
        #2;

        #1;


        check_outputs(0, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input expected_miso;
        input expected_state;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: miso=%b, state=%b",
                         miso, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b, state=%b",
                         expected_miso, expected_state);
                $display("  Got:      miso=%b, state=%b",
                         miso, state);
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
        $dumpvars(0,clk, cs, mosi, miso, state);
    end

endmodule

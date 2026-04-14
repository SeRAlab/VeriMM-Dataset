`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg CS;
    reg MOSI;
    reg SCK;
    reg clk;
    reg reset;
    wire MISO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK),
        .clk(clk),
        .reset(reset),
        .MISO(MISO)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        CS = 1;
        SCK = 0;
        MOSI = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset State and CS High Check", test_num);
        reset_dut();
        CS = 1;
        MOSI = 1;
        SCK = 0;
        #20;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Capture MOSI '1' with CS Low", test_num);
        reset_dut();
        CS = 0;
        MOSI = 1;
        #10;
        SCK = 1;
        #10;
        SCK = 0;
        #10;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Capture MOSI '0' with CS Low", test_num);
        reset_dut();
        CS = 0;
        MOSI = 0;
        #10;
        SCK = 1;
        #10;
        SCK = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Verify SCK Ignored when CS is High", test_num);
        reset_dut();


        CS = 1;
        MOSI = 1;
        #10 SCK = 1; #10 SCK = 0;



        CS = 0;
        MOSI = 0;
        #10 SCK = 1; #10 SCK = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Sequential Bit Transfer (1-0-1)", test_num);
        reset_dut();
        CS = 0;


        MOSI = 1;
        #10 SCK = 1; #10 SCK = 0;


        MOSI = 0;
        #10 SCK = 1; #10 SCK = 0;


        MOSI = 1;
        #10 SCK = 1; #10 SCK = 0;

        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_MISO;
        begin
            if (expected_MISO === (expected_MISO ^ MISO ^ expected_MISO)) begin
                $display("PASS");
                $display("  Outputs: MISO=%b",
                         MISO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MISO=%b",
                         expected_MISO);
                $display("  Got:      MISO=%b",
                         MISO);
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
        $dumpvars(0,CS, MOSI, SCK, clk, reset, MISO);
    end

endmodule

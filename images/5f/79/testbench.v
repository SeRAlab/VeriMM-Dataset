`timescale 1ns/1ps

module ring_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    wire [4:0] ring;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter dut (
        .clk(clk),
        .clr(clr),
        .ring(ring)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            @(posedge clk);
            #1 clr = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Checking initial state after reset...", test_num);
            reset_dut();
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Checking state after 1 clock cycle...", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(5'b01000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Checking state after 2 clock cycles...", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(5'b00100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Checking state after 3 clock cycles...", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(5'b00010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Checking state after 4 clock cycles...", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(5'b00001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Checking wrap-around after 5 clock cycles...", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(5'b10000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Checking multiple wrap-arounds (12 cycles)...", test_num);
            reset_dut();
            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(5'b00100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Verifying synchronous clear mid-sequence...", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            clr = 1;
            @(posedge clk);
            #1 clr = 0;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter Testbench");
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
        input [4:0] expected_ring;
        begin
            if (expected_ring === (expected_ring ^ ring ^ expected_ring)) begin
                $display("PASS");
                $display("  Outputs: ring=%h",
                         ring);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring=%h",
                         expected_ring);
                $display("  Got:      ring=%h",
                         ring);
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
        $dumpvars(0,clk, clr, ring);
    end

endmodule

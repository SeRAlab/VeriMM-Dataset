`timescale 1ns/1ps

module binary_search_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] array;
    reg clk;
    reg [2:0] target;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_search dut (
        .array(array),
        .clk(clk),
        .target(target),
        .found(found)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            array = 8'b0;
            target = 3'b0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            array = 8'b10000000;
            target = 3'b001;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Search for 1 in 8'b10000000", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            array = 8'b00000000;
            target = 3'b001;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Search for 1 in all zeros", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            array = 8'b11111110;
            target = 3'b000;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Search for 0 in 8'b11111110", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            array = 8'b11111111;
            target = 3'b000;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Search for 0 in all ones", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            array = 8'b11110000;
            target = 3'b001;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Search for 1 in 8'b11110000", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            array = 8'b11000000;
            target = 3'b000;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Search for 0 in 8'b11000000", test_num);
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
        $display("binary_search Testbench");
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
        input expected_found;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found)) begin
                $display("PASS");
                $display("  Outputs: found=%b",
                         found);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b",
                         expected_found);
                $display("  Got:      found=%b",
                         found);
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
        $dumpvars(0,array, clk, target, found);
    end

endmodule

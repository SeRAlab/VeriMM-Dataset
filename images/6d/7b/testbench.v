`timescale 1ns/1ps

module gray_counter_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    wire [2:0] gray_counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_counter dut (
        .clock(clock),
        .gray_counter(gray_counter)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin


            if (gray_counter !== 3'b000) begin
                while (gray_counter !== 3'b000) @(posedge clock);
            end


            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 1 clock cycle", test_num);
            reset_dut();
            repeat(1) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 2 clock cycles", test_num);
            reset_dut();
            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 3 clock cycles", test_num);
            reset_dut();
            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 4 clock cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 5 clock cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 6 clock cycles", test_num);
            reset_dut();
            repeat(6) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 7 clock cycles", test_num);
            reset_dut();
            repeat(7) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap around after 8 cycles", test_num);
            reset_dut();
            repeat(8) @(posedge clock);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_counter Testbench");
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
        input [2:0] expected_gray_counter;
        begin
            if (expected_gray_counter === (expected_gray_counter ^ gray_counter ^ expected_gray_counter)) begin
                $display("PASS");
                $display("  Outputs: gray_counter=%h",
                         gray_counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_counter=%h",
                         expected_gray_counter);
                $display("  Got:      gray_counter=%h",
                         gray_counter);
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
        $dumpvars(0,clock, gray_counter);
    end

endmodule

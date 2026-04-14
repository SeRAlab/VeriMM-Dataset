`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] current_state;
    wire [2:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .current_state(current_state),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            current_state = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: State 000", test_num);
            current_state = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: State 001", test_num);
            current_state = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: State 010", test_num);
            current_state = 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: State 011", test_num);
            current_state = 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: State 100", test_num);
            current_state = 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: State 101", test_num);
            current_state = 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: State 110", test_num);
            current_state = 3'b110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: State 111", test_num);
            current_state = 3'b111;
            @(posedge clk);
            #2;
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
        $display("deadbeat_controller Testbench");
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
        input [2:0] expected_next_state;
        begin
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
        $dumpvars(0,clk, current_state, next_state);
    end

endmodule

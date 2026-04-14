`timescale 1ns/1ps

module state_space_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_input;
    reg [3:0] current_state;
    reg rst;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_space_controller dut (
        .clk(clk),
        .control_input(control_input),
        .current_state(current_state),
        .rst(rst),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            control_input = 0;
            current_state = 4'b0000;
            @(posedge clk);
            rst = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            current_state = 4'b0000;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0000, Input 0", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            current_state = 4'b0000;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0000, Input 1", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            current_state = 4'b0001;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0001, Input 0", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            current_state = 4'b0001;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0001, Input 1", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            current_state = 4'b0010;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0010, Input 0", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            current_state = 4'b0010;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0010, Input 1", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            current_state = 4'b0011;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0011, Input 0", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            current_state = 4'b0011;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0011, Input 1", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            current_state = 4'b0100;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0100, Input 0", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            current_state = 4'b0100;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0100, Input 1", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_dut();
            current_state = 4'b0101;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0101, Input 0", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            reset_dut();
            current_state = 4'b0101;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0101, Input 1", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            reset_dut();
            current_state = 4'b0110;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0110, Input 0", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            reset_dut();
            current_state = 4'b0110;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0110, Input 1", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            reset_dut();
            current_state = 4'b0111;
            control_input = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0111, Input 0", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            reset_dut();
            current_state = 4'b0111;
            control_input = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: State 0111, Input 1", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_space_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_next_state;
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
        $dumpvars(0,clk, control_input, current_state, rst, next_state);
    end

endmodule

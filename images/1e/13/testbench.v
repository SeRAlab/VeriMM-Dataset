`timescale 1ns/1ps

module state_space_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_input;
    reg rst;
    reg [2:0] state_in;
    wire [2:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_space_controller dut (
        .clk(clk),
        .control_input(control_input),
        .rst(rst),
        .state_in(state_in),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control_input = 0;
            state_in = 3'b000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 0, Input 0", test_num);
            reset_dut();
            state_in = 3'b000;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 0, Input 1", test_num);
            reset_dut();
            state_in = 3'b000;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 1, Input 0", test_num);
            reset_dut();
            state_in = 3'b001;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 1, Input 1", test_num);
            reset_dut();
            state_in = 3'b001;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 2, Input 0", test_num);
            reset_dut();
            state_in = 3'b010;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 2, Input 1", test_num);
            reset_dut();
            state_in = 3'b010;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 3, Input 0", test_num);
            reset_dut();
            state_in = 3'b011;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 3, Input 1", test_num);
            reset_dut();
            state_in = 3'b011;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 4, Input 0", test_num);
            reset_dut();
            state_in = 3'b100;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 4, Input 1", test_num);
            reset_dut();
            state_in = 3'b100;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 5, Input 0", test_num);
            reset_dut();
            state_in = 3'b101;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 5, Input 1", test_num);
            reset_dut();
            state_in = 3'b101;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b101);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 6, Input 0", test_num);
            reset_dut();
            state_in = 3'b110;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b101);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 6, Input 1", test_num);
            reset_dut();
            state_in = 3'b110;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 7, Input 0", test_num);
            reset_dut();
            state_in = 3'b111;
            control_input = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b110);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State 7, Input 1", test_num);
            reset_dut();
            state_in = 3'b111;
            control_input = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b111);
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
        input [2:0] expected_state_out;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
        $dumpvars(0,clk, control_input, rst, state_in, state_out);
    end

endmodule

`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg load;
    reg shift_left;
    reg shift_right;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .data_in(data_in),
        .load(load),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        load = 0;
        forever #5 load = ~load;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            $display("DUT Reset to 0000");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();
            data_in = 4'b1010;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left", test_num);
            reset_dut();

            data_in = 4'b0001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Right", test_num);
            reset_dut();

            data_in = 4'b1000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-cycle Shift Left", test_num);
            reset_dut();
            data_in = 4'b0111;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-cycle Shift Right", test_num);
            reset_dut();
            data_in = 4'b1110;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_right = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority (Load over Shift)", test_num);
            reset_dut();

            data_in = 4'b1010;
            load = 1;
            @(posedge clk);
            #1;

            data_in = 4'b1111;
            load = 1;
            shift_left = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold Value", test_num);
            reset_dut();
            data_in = 4'b0101;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left until Empty", test_num);
            reset_dut();
            data_in = 4'b1000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            repeat(4) @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,data_in, load, shift_left, shift_right, data_out);
    end

endmodule

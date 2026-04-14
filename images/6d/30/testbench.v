`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg rst;
    reg shift_left;
    reg shift_right;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Parallel Load", test_num);
            reset_dut();
            load = 1;
            data_in = 4'b1011;
            @(posedge clk);
            load = 0;
            #1 #1;
 check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Shift Left", test_num);
            reset_dut();

            load = 1;
            data_in = 4'b0001;
            @(posedge clk);

            load = 0;
            shift_left = 1;
            @(posedge clk);
            @(posedge clk);
            shift_left = 0;
            #1 #1;
 check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Shift Right", test_num);
            reset_dut();

            load = 1;
            data_in = 4'b1000;
            @(posedge clk);

            load = 0;
            shift_right = 1;
            @(posedge clk);
            @(posedge clk);
            shift_right = 0;
            #1 #1;
 check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Hold Current Value", test_num);
            reset_dut();

            load = 1;
            data_in = 4'b1101;
            @(posedge clk);

            load = 0;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority (Load over Shift)", test_num);
            reset_dut();
            load = 1;
            data_in = 4'b1111;
            shift_left = 1;
            shift_right = 1;
            @(posedge clk);
            load = 0;
            shift_left = 0;
            shift_right = 0;
            #1 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Shift Left Clear", test_num);
            reset_dut();
            load = 1;
            data_in = 4'b1000;
            @(posedge clk);
            load = 0;
            shift_left = 1;
            @(posedge clk);
            shift_left = 0;
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Left then Right Sequence", test_num);
            reset_dut();
            load = 1;
            data_in = 4'b0110;
            @(posedge clk);
            load = 0;
            shift_left = 1;
            @(posedge clk);
            shift_left = 0;
            shift_right = 1;
            @(posedge clk);
            shift_right = 0;
            #1 #1;
 check_outputs(4'b0110);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, rst, shift_left, shift_right, q);
    end

endmodule

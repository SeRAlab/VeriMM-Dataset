`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] clear;
    reg clk;
    reg rst;
    reg [4:0] set;
    wire [4:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clear(clear),
        .clk(clk),
        .rst(rst),
        .set(set),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            set = 0;
            clear = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Simple Set Operation", test_num);
            reset_dut();
            set = 5'b10101;
            @(posedge clk);
            #1 set = 0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simple Clear Operation", test_num);
            reset_dut();
            set = 5'b11111;
            @(posedge clk);
            #1 set = 0;
            clear = 5'b01010;
            @(posedge clk);
            #1 clear = 0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Combined Set and Clear", test_num);
            reset_dut();
            set = 5'b11000;
            @(posedge clk);
            #1 set = 5'b00001;
            clear = 5'b10000;
            @(posedge clk);
            #1;
            set = 0;
            clear = 0;
            #1;

            check_outputs(5'b01001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Conflict Resolution (Same Pin)", test_num);
            reset_dut();
            set = 5'b11111;
            clear = 5'b11111;
            @(posedge clk);
            #1 set = 0;
            clear = 0;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Data Persistence", test_num);
            reset_dut();
            set = 5'b01100;
            @(posedge clk);
            #1 set = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(5'b01100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Sequential Accumulation", test_num);
            reset_dut();
            set = 5'b00001; @(posedge clk); #1;
            set = 5'b00010; @(posedge clk); #1;
            set = 5'b00100; @(posedge clk); #1;
            set = 0;
            #1;

            check_outputs(5'b00111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [4:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clear, clk, rst, set, state);
    end

endmodule

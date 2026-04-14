`timescale 1ns/1ps

module gray_code_counter_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] binary_value;
    reg clk;
    reg en;
    reg load;
    reg rst;
    wire [6:0] gray_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter dut (
        .binary_value(binary_value),
        .clk(clk),
        .en(en),
        .load(load),
        .rst(rst),
        .gray_code(gray_code)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 0;
        en = 0;
        load = 0;
        binary_value = 0;
        #12;
        rst = 1;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(bin_to_gray(7'd0));
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Increment (Count to 5)", test_num);
        reset_dut();
        en = 1;
        repeat(5) @(negedge clk);
        en = 0;

        #1;


        check_outputs(bin_to_gray(7'd5));
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load binary value 42", test_num);
        reset_dut();
        binary_value = 7'd42;
        load = 1;
        @(negedge clk);
        load = 0;

        #1;


        check_outputs(bin_to_gray(7'd42));
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable signal control (en=0)", test_num);
        reset_dut();
        en = 0;
        repeat(10) @(negedge clk);

        #1;


        check_outputs(bin_to_gray(7'd0));
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Roll-over test (127 -> 0)", test_num);
        reset_dut();

        binary_value = 7'd127;
        load = 1;
        @(negedge clk);
        load = 0;
        en = 1;
        @(negedge clk);
        en = 0;
        #1;

        check_outputs(bin_to_gray(7'd0));
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Load 10 then increment 3 times", test_num);
        reset_dut();
        binary_value = 7'd10;
        load = 1;
        @(negedge clk);
        load = 0;
        en = 1;
        repeat(3) @(negedge clk);
        en = 0;
        #1;

        check_outputs(bin_to_gray(7'd13));
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Load priority over enable", test_num);
        reset_dut();
        binary_value = 7'd50;
        load = 1;
        en = 1;
        @(negedge clk);
        load = 0;
        en = 0;
        #1;

        check_outputs(bin_to_gray(7'd50));
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code_counter Testbench");
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
        input [6:0] expected_gray_code;
        begin
            if (expected_gray_code === (expected_gray_code ^ gray_code ^ expected_gray_code)) begin
                $display("PASS");
                $display("  Outputs: gray_code=%h",
                         gray_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_code=%h",
                         expected_gray_code);
                $display("  Got:      gray_code=%h",
                         gray_code);
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
        $dumpvars(0,binary_value, clk, en, load, rst, gray_code);
    end

endmodule

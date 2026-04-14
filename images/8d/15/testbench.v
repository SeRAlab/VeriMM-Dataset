`timescale 1ns/1ps

module register_8bit_async_reset_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit_async_reset dut (
        .clk(clk),
        .data(data),
        .rst(rst),
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
        data = 8'h00;
        #15;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write 0xFF", test_num);
        reset_dut();
        data = 8'hFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write 0x5A", test_num);
        reset_dut();
        data = 8'h5A;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Asynchronous Reset Check", test_num);
        reset_dut();
        data = 8'hA5;
        @(posedge clk);
        #2;
        rst = 1;
        #1;
        #1;

        check_outputs(8'h00);
        rst = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Clock Edge Sensitivity Check", test_num);
        reset_dut();
        data = 8'h11;
        @(posedge clk);
        #2;
        data = 8'h22;
        #2;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset Dominance Check", test_num);
        reset_dut();
        rst = 1;
        data = 8'hCC;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
        rst = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Sequential Writes", test_num);
        reset_dut();
        data = 8'h10;
        @(posedge clk);
        #2;
        data = 8'h20;
        @(posedge clk);
        #2;
        data = 8'h30;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_8bit_async_reset Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, data, rst, q);
    end

endmodule

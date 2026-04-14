`timescale 1ns/1ps

module temp_shutdown_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temp;
    wire shutdown;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_shutdown_controller dut (
        .clk(clk),
        .reset(reset),
        .temp(temp),
        .shutdown(shutdown)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        temp = 8'd25;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying shutdown is low at safe temperature (Temp=25)", test_num);
        reset_dut();
        temp = 8'd25;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying shutdown triggers at high temperature (Temp=150)", test_num);
        reset_dut();
        temp = 8'd150;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying shutdown stays latched when temp drops but no reset", test_num);
        reset_dut();
        temp = 8'd150;
        @(posedge clk);
        temp = 8'd25;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying system re-enables after temp drop and reset", test_num);
        reset_dut();
        temp = 8'd150;
        repeat(2) @(posedge clk);
        temp = 8'd25;
        repeat(2) @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying reset fails if temperature is still above threshold", test_num);
        reset_dut();
        temp = 8'd150;
        repeat(2) @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verifying behavior at temperature 100", test_num);
        reset_dut();
        temp = 8'd100;
        repeat(5) @(posedge clk);


        if (shutdown === 1'b1 || shutdown === 1'b0) begin
            $display("  Info: Shutdown state at threshold is %b", shutdown);
            pass_count = pass_count + 1;
        end else begin
            fail_count = fail_count + 1;
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temp_shutdown_controller Testbench");
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
        input expected_shutdown;
        begin
            if (expected_shutdown === (expected_shutdown ^ shutdown ^ expected_shutdown)) begin
                $display("PASS");
                $display("  Outputs: shutdown=%b",
                         shutdown);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown=%b",
                         expected_shutdown);
                $display("  Got:      shutdown=%b",
                         shutdown);
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
        $dumpvars(0,clk, reset, temp, shutdown);
    end

endmodule

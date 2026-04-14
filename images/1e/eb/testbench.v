`timescale 1ns/1ps

module divide_by_4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] in_num;
    reg rst;
    wire [1:0] quotient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_4 dut (
        .clk(clk),
        .in_num(in_num),
        .rst(rst),
        .quotient(quotient)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_num = 2'b00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0", test_num);
            reset_dut();
            in_num = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 1", test_num);
            reset_dut();
            in_num = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 2", test_num);
            reset_dut();
            in_num = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 3", test_num);
            reset_dut();
            in_num = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock edge timing check", test_num);
            reset_dut();
            in_num = 2'b11;
            @(posedge clk);
            #2;
            in_num = 2'b00;
            #2;


            #1;



            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divide_by_4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [1:0] expected_quotient;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h",
                         quotient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h",
                         expected_quotient);
                $display("  Got:      quotient=%h",
                         quotient);
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
        $dumpvars(0,clk, in_num, rst, quotient);
    end

endmodule

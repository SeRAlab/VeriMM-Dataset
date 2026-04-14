`timescale 1ns/1ps

module FlashMemoryCell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg WE;
    reg clk;
    reg rst;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FlashMemoryCell dut (
        .D(D),
        .WE(WE),
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            D = 0;
            WE = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write (0xA5)", test_num);
            reset_dut();
            D = 8'hA5;
            WE = 1;
            @(posedge clk);
            #1 WE = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data Hold (WE=0)", test_num);
            reset_dut();

            D = 8'h55;
            WE = 1;
            @(posedge clk);
            #1 WE = 0;

            D = 8'hFF;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Consecutive Writes", test_num);
            reset_dut();

            D = 8'h11;
            WE = 1;
            @(posedge clk);

            #1 D = 8'h22;
            @(posedge clk);
            #1 WE = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write 0xFF then 0x00", test_num);
            reset_dut();

            D = 8'hFF;
            WE = 1;
            @(posedge clk);

            #1 D = 8'h00;
            @(posedge clk);
            #1 WE = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset after successful write", test_num);
            reset_dut();
            D = 8'h77;
            WE = 1;
            @(posedge clk);
            #1 WE = 0;
            @(posedge clk);

            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FlashMemoryCell Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, WE, clk, rst, Q);
    end

endmodule

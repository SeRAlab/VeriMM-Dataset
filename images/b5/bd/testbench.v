`timescale 1ns/1ps

module Register_16_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D;
    reg clk;
    reg clr;
    reg load;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Register_16 dut (
        .D(D),
        .clk(clk),
        .clr(clr),
        .load(load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            load = 0;
            D = 16'h0000;
            @(posedge clk);
            #1;
            clr = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Synchronous Load (0xABCD)", test_num);
            reset_dut();
            @(negedge clk);
            D = 16'hABCD;
            load = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Data Retention (Load=0)", test_num);
            reset_dut();

            @(negedge clk);
            D = 16'h1234;
            load = 1;
            clr = 0;
            @(posedge clk);
            #1;

            @(negedge clk);
            load = 0;
            D = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Clear Priority over Load", test_num);
            reset_dut();

            @(negedge clk);
            D = 16'h5555;
            load = 1;
            clr = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Load All Ones", test_num);
            reset_dut();
            @(negedge clk);
            D = 16'hFFFF;
            load = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Load All Zeros via Load Signal", test_num);
            reset_dut();

            @(negedge clk);
            D = 16'hAAAA;
            load = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            D = 16'h0000;
            load = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Register_16 Testbench");
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
        input [15:0] expected_Q;
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
        $dumpvars(0,D, clk, clr, load, Q);
    end

endmodule

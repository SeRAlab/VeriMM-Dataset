`timescale 1ns/1ps

module bus_hold_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bus_in;
    reg clk;
    reg reset;
    wire [7:0] bus_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bus_hold dut (
        .bus_in(bus_in),
        .clk(clk),
        .reset(reset),
        .bus_out(bus_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("  Resetting DUT...");
            reset = 1;
            bus_in = 8'h00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Latch Value on Rising Edge", test_num);
            reset_dut();

            bus_in = 8'hA5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Hold Value when Clock is Low", test_num);
            reset_dut();


            bus_in = 8'h5A;
            @(posedge clk);
            #2;


            @(negedge clk);
            #2;


            bus_in = 8'hFF;
            #5;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Consecutive Samples", test_num);
            reset_dut();


            bus_in = 8'h11;
            @(posedge clk);
            #2;


            bus_in = 8'h22;
            @(posedge clk);
            #2;


            bus_in = 8'h33;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mid-operation Reset", test_num);
            reset_dut();


            bus_in = 8'hCC;
            @(posedge clk);
            #2;


            reset = 1;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Data Stability (DFF behavior)", test_num);
            reset_dut();

            bus_in = 8'h88;
            @(posedge clk);
            #2;



            bus_in = 8'h99;
            #2;

            #1;


            check_outputs(8'h88);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bus_hold Testbench");
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
        input [7:0] expected_bus_out;
        begin
            if (expected_bus_out === (expected_bus_out ^ bus_out ^ expected_bus_out)) begin
                $display("PASS");
                $display("  Outputs: bus_out=%h",
                         bus_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_out=%h",
                         expected_bus_out);
                $display("  Got:      bus_out=%h",
                         bus_out);
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
        $dumpvars(0,bus_in, clk, reset, bus_out);
    end

endmodule

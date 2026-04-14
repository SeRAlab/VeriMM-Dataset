`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    wire [1:0] mod_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .mod_out(mod_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            data_in <= 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 4'b0000", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 4'b0001", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 4'b0010", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 4'b0010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 4'b0011", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 4'b0011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input 4'b1100", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 4'b1100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State Transition 10 -> 11", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 4'b0010;
            @(posedge clk);
            @(negedge clk);
            data_in = 4'b0011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        input [1:0] expected_mod_out;
        begin
            if (expected_mod_out === (expected_mod_out ^ mod_out ^ expected_mod_out)) begin
                $display("PASS");
                $display("  Outputs: mod_out=%h",
                         mod_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mod_out=%h",
                         expected_mod_out);
                $display("  Got:      mod_out=%h",
                         mod_out);
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
        $dumpvars(0,clk, data_in, mod_out);
    end

endmodule

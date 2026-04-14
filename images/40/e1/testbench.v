`timescale 1ns/1ps

module eeprom_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 0;
            data_in = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Write 0xA)", test_num);
            reset_dut();


            control = 1;
            data_in = 4'hA;
            @(posedge clk);
            #1;


            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting data (0x5 then 0xF)", test_num);
            reset_dut();


            control = 1;
            data_in = 4'h5;
            @(posedge clk);
            #1;


            control = 1;
            data_in = 4'hF;
            @(posedge clk);
            #1;


            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence (data_in changes while reading)", test_num);
            reset_dut();


            control = 1;
            data_in = 4'h3;
            @(posedge clk);
            #1;


            control = 0;
            @(posedge clk);
            #1;


            data_in = 4'hE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writing/Reading All Zeros", test_num);
            reset_dut();


            control = 1;
            data_in = 4'hF;
            @(posedge clk);
            #1;


            control = 1;
            data_in = 4'h0;
            @(posedge clk);
            #1;


            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify no-write when control is low", test_num);
            reset_dut();


            control = 1;
            data_in = 4'hC;
            @(posedge clk);
            #1;


            control = 0;
            data_in = 4'h7;
            @(posedge clk);
            #1;


            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, control, data_in, data_out);
    end

endmodule

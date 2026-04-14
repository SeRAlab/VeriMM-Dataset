`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Data Transmission (Valid=1)", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'hAA;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Ignore Data when Valid=0", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'h55;
            valid = 1;
            @(posedge clk);


            @(negedge clk);
            data_in = 8'hFF;
            valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Consecutive Transmissions", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'h11;
            valid = 1;
            @(posedge clk);

            @(negedge clk);
            data_in = 8'h22;
            valid = 1;
            @(posedge clk);

            @(negedge clk);
            data_in = 8'h33;
            valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Intermittent Valid Signals", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'hDE;
            valid = 1;
            @(posedge clk);


            @(negedge clk);
            data_in = 8'h00;
            valid = 0;
            @(posedge clk);


            @(negedge clk);
            data_in = 8'hAD;
            valid = 1;
            @(posedge clk);


            @(negedge clk);
            data_in = 8'hBE;
            valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hAD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Bus Changes with Valid Low", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'hA1;
            valid = 1;
            @(posedge clk);

            @(negedge clk);
            valid = 0;
            data_in = 8'hB2; @(posedge clk);
            data_in = 8'hC3; @(posedge clk);
            data_in = 8'hD4; @(posedge clk);
            #1;


            #1;



            check_outputs(8'hA1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, reset, valid, data_out);
    end

endmodule

`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire status;

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
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            data_in = 8'h00;
            valid = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: System Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Successful Packet Reception", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            data_in = 8'h55; @(posedge clk);
            data_in = 8'hD5; @(posedge clk);
            data_in = 8'hAA; @(posedge clk);
            data_in = 8'hBB; @(posedge clk);
            data_in = 8'hCC; @(posedge clk);
            valid = 0;
            data_in = 8'h00;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Short Packet Error Check", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            data_in = 8'h55; @(posedge clk);
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Long Packet Reception", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            for (i = 0; i < 64; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
            end
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Interrupted Packet Check", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            data_in = 8'hAA; @(posedge clk);
            valid = 0;
            @(posedge clk);
            valid = 1;
            data_in = 8'hBB; @(posedge clk);
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%b",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%b",
                         expected_status);
                $display("  Got:      status=%b",
                         status);
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
        $dumpvars(0,clk, data_in, reset, valid, status);
    end

endmodule

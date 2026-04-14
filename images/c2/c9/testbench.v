`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data;
    reg [3:0] shift_amount;
    wire [15:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data(data),
        .shift_amount(shift_amount),
        .shifted_data(shifted_data)
    );

        task reset_dut;

        begin
            rst_n = 0;
            data = 0;
            shift_amount = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data = 16'hABCD;
            shift_amount = 4'd0;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data = 16'h0001;
            shift_amount = 4'd1;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data = 16'h1234;
            shift_amount = 4'd4;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'h2340);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data = 16'h00FF;
            shift_amount = 4'd8;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data = 16'h000F;
            shift_amount = 4'd12;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'hF000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data = 16'h0001;
            shift_amount = 4'd15;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data = 16'h8000;
            shift_amount = 4'd1;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            data = 16'hAAAA;
            shift_amount = 4'd2;
            repeat(LATENCY) @(posedge clk);
            #1 #1;
 check_outputs(16'hAAA8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_shifted_data;
        begin
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
        $dumpvars(0,data, shift_amount, shifted_data);
    end

endmodule

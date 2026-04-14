`timescale 1ns/1ps

module VirtualMemoryManager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] logical_address;
    reg reset;
    reg valid_bit;
    wire error_signal;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManager dut (
        .clk(clk),
        .logical_address(logical_address),
        .reset(reset),
        .valid_bit(valid_bit),
        .error_signal(error_signal),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            logical_address = 8'h0;
            valid_bit = 0;
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
            $display("Testcase %0d: Valid address mapping (0x05)", test_num);
            reset_dut();
            logical_address = 8'h05;
            valid_bit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h05);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid address mapping (0xAA)", test_num);
            reset_dut();
            logical_address = 8'hAA;
            valid_bit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid bit set", test_num);
            reset_dut();
            logical_address = 8'h12;
            valid_bit = 0;
            @(posedge clk);
            #2;


            if (error_signal === 1'b1) begin
                $display("PASS");
                $display("  Outputs: error_signal=%b", error_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_signal=1");
                $display("  Got:      error_signal=%b", error_signal);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address (0xFF)", test_num);
            reset_dut();
            logical_address = 8'hFF;
            valid_bit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address (0x00)", test_num);
            reset_dut();
            logical_address = 8'h00;
            valid_bit = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence of two valid addresses", test_num);
            reset_dut();

            logical_address = 8'h10;
            valid_bit = 1;
            @(posedge clk);
            #2;

            logical_address = 8'h20;
            valid_bit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid then Invalid access", test_num);
            reset_dut();


            logical_address = 8'h55;
            valid_bit = 1;
            @(posedge clk);
            #2;


            logical_address = 8'h66;
            valid_bit = 0;
            @(posedge clk);
            #2;


            if (error_signal === 1'b1) begin
                $display("PASS");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Operation immediately after reset", test_num);
            reset_dut();

            logical_address = 8'hDE;
            valid_bit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'hDE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManager Testbench");
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
        input expected_error_signal;
        input [7:0] expected_physical_address;
        begin
            if (expected_error_signal === (expected_error_signal ^ error_signal ^ expected_error_signal) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: error_signal=%b, physical_address=%h",
                         error_signal, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_signal=%b, physical_address=%h",
                         expected_error_signal, expected_physical_address);
                $display("  Got:      error_signal=%b, physical_address=%h",
                         error_signal, physical_address);
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
        $dumpvars(0,clk, logical_address, reset, valid_bit, error_signal, physical_address);
    end

endmodule

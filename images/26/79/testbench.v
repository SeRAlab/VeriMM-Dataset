`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg rst_n;
    wire address_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .address(address),
        .clk(clk),
        .rst_n(rst_n),
        .address_valid(address_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            rst_n = 0;
            address = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Address below range (0x00000000)", test_num);
            reset_dut();
            address = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Address just below lower bound (0x00000FFF)", test_num);
            reset_dut();
            address = 32'h0000_0FFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Address at lower bound (0x00001000)", test_num);
            reset_dut();
            address = 32'h0000_1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Address in mid-range (0x00008000)", test_num);
            reset_dut();
            address = 32'h0000_8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Address at upper bound (0x0000FFFF)", test_num);
            reset_dut();
            address = 32'h0000_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Address just above upper bound (0x00010000)", test_num);
            reset_dut();
            address = 32'h0001_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Address far above range (0xDEADBEEF)", test_num);
            reset_dut();
            address = 32'hDEAD_BEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Maximum 32-bit address (0xFFFFFFFF)", test_num);
            reset_dut();
            address = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
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
        $display("pcie_endpoint_controller Testbench");
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
        input expected_address_valid;
        begin
            if (expected_address_valid === (expected_address_valid ^ address_valid ^ expected_address_valid)) begin
                $display("PASS");
                $display("  Outputs: address_valid=%b",
                         address_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_valid=%b",
                         expected_address_valid);
                $display("  Got:      address_valid=%b",
                         address_valid);
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
        $dumpvars(0,address, clk, rst_n, address_valid);
    end

endmodule

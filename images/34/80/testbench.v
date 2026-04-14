`timescale 1ns/1ps

module vm_address_translation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] virtual_address;
    wire [31:0] physical_address;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vm_address_translation dut (
        .clk(clk),
        .reset(reset),
        .virtual_address(virtual_address),
        .physical_address(physical_address),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            virtual_address = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Translation of Virtual Address 0x00000000 (VPN 0, Offset 0)", test_num);
            reset_dut();
            virtual_address = 32'h00000000;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Translation of Virtual Address 0x00001ABC (VPN 1, Offset ABC)", test_num);
            reset_dut();
            virtual_address = 32'h00001ABC;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00001ABC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Translation of Virtual Address 0x0000F555 (VPN F, Offset 555)", test_num);
            reset_dut();
            virtual_address = 32'h0000F555;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000F555, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Translation of Virtual Address 0x00002FFF (VPN 2, Max Offset)", test_num);
            reset_dut();
            virtual_address = 32'h00002FFF;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00002FFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: System state during reset", test_num);
            reset = 1;
            virtual_address = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 1'b0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vm_address_translation Testbench");
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
        input [31:0] expected_physical_address;
        input expected_valid;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h, valid=%b",
                         physical_address, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h, valid=%b",
                         expected_physical_address, expected_valid);
                $display("  Got:      physical_address=%h, valid=%b",
                         physical_address, valid);
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
        $dumpvars(0,clk, reset, virtual_address, physical_address, valid);
    end

endmodule

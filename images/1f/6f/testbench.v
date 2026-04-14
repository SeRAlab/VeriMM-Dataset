`timescale 1ns/1ps

module MMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] virtual_address;
    wire [15:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MMU dut (
        .clk(clk),
        .rst(rst),
        .virtual_address(virtual_address),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            virtual_address = 16'h0000;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: VPN 0x0 Translation", test_num);
            reset_dut();
            virtual_address = 16'h0005;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h2005);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: VPN 0x1 Translation", test_num);
            reset_dut();
            virtual_address = 16'h1ABC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h3ABC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: VPN 0x2 Translation (Offset Check)", test_num);
            reset_dut();
            virtual_address = 16'h2FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: VPN 0x3 Translation", test_num);
            reset_dut();
            virtual_address = 16'h3000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: VPN 0xF Translation", test_num);
            reset_dut();
            virtual_address = 16'hF123;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hE123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid Address Change", test_num);
            reset_dut();


            virtual_address = 16'h0AAA;
            @(posedge clk);
            #2;


            virtual_address = 16'h1BBB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h3BBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MMU Testbench");
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
        input [15:0] expected_physical_address;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h",
                         physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h",
                         expected_physical_address);
                $display("  Got:      physical_address=%h",
                         physical_address);
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
        $dumpvars(0,clk, rst, virtual_address, physical_address);
    end

endmodule

`timescale 1ns/1ps

module VirtualMemoryMMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] virtual_address;
    wire [3:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryMMU dut (
        .clk(clk),
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
            virtual_address <= 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            virtual_address <= 4'h0;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Testing Virtual Address 0x0 (Valid Entry 1)", test_num);

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            virtual_address <= 4'h1;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Testing Virtual Address 0x1 (Valid Entry 2)", test_num);

            #1;


            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            virtual_address <= 4'h2;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Testing Virtual Address 0x2 (Valid Entry 3)", test_num);

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            virtual_address <= 4'h3;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Testing Virtual Address 0x3 (Valid Entry 4)", test_num);

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            virtual_address <= 4'h4;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Testing Invalid Virtual Address 0x4", test_num);

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            virtual_address <= 4'h8;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Testing Invalid Virtual Address 0x8", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            virtual_address <= 4'hF;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Testing Invalid Virtual Address 0xF", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryMMU Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_physical_address;
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
        $dumpvars(0,clk, virtual_address, physical_address);
    end

endmodule

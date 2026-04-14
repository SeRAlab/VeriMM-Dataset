`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [1:0] sel;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting data0 (Basic hex value)", test_num);
            data0 = 32'hDEADBEEF;
            data1 = 32'hCAFEBABE;
            data2 = 32'h12345678;
            data3 = 32'h87654321;
            sel = 2'b00;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting data1 (Basic hex value)", test_num);
            data0 = 32'hDEADBEEF;
            data1 = 32'hCAFEBABE;
            data2 = 32'h12345678;
            data3 = 32'h87654321;
            sel = 2'b01;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting data2 (Basic hex value)", test_num);
            data0 = 32'hDEADBEEF;
            data1 = 32'hCAFEBABE;
            data2 = 32'h12345678;
            data3 = 32'h87654321;
            sel = 2'b10;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting data3 (Basic hex value)", test_num);
            data0 = 32'hDEADBEEF;
            data1 = 32'hCAFEBABE;
            data2 = 32'h12345678;
            data3 = 32'h87654321;
            sel = 2'b11;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Inputs Zero Boundary Test", test_num);
            data0 = 32'h00000000;
            data1 = 32'h00000000;
            data2 = 32'h00000000;
            data3 = 32'h00000000;
            sel = 2'b10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Inputs Ones Boundary Test", test_num);
            data0 = 32'hFFFFFFFF;
            data1 = 32'hFFFFFFFF;
            data2 = 32'hFFFFFFFF;
            data3 = 32'hFFFFFFFF;
            sel = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking Bit Test", test_num);
            data0 = 32'h00000001;
            data1 = 32'h00000002;
            data2 = 32'h00000004;
            data3 = 32'h00000008;
            sel = 2'b11;
            #1;

            check_outputs(32'h00000008);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Pattern Test", test_num);
            data0 = 32'hAAAAAAAA;
            data1 = 32'h55555555;
            data2 = 32'hF0F0F0F0;
            data3 = 32'h0F0F0F0F;
            sel = 2'b00;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule

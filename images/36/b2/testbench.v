`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [1:0] select;
    wire [31:0] mux_out;

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
        .select(select),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select data0", test_num);
            data0 = 32'hAAAAAAAA;
            data1 = 32'h00000000;
            data2 = 32'hFFFFFFFF;
            data3 = 32'h55555555;
            select = 2'b00;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select data1", test_num);
            data0 = 32'h00000000;
            data1 = 32'h55555555;
            data2 = 32'hAAAAAAAA;
            data3 = 32'hFFFFFFFF;
            select = 2'b01;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select data2", test_num);
            data0 = 32'hFFFFFFFF;
            data1 = 32'hAAAAAAAA;
            data2 = 32'h12345678;
            data3 = 32'h00000000;
            select = 2'b10;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select data3", test_num);
            data0 = 32'h55555555;
            data1 = 32'h12345678;
            data2 = 32'h00000000;
            data3 = 32'hDEADBEEF;
            select = 2'b11;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones on data0", test_num);
            data0 = 32'hFFFFFFFF;
            data1 = 32'h0;
            data2 = 32'h0;
            data3 = 32'h0;
            select = 2'b00;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros on data1", test_num);
            data0 = 32'hFFFFFFFF;
            data1 = 32'h00000000;
            data2 = 32'hFFFFFFFF;
            data3 = 32'hFFFFFFFF;
            select = 2'b01;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change unselected inputs", test_num);
            data0 = 32'hCAFECAFE;
            data1 = 32'h0;
            data2 = 32'h0;
            data3 = 32'h0;
            select = 2'b00;
            #5;
            data1 = 32'hFFFFFFFF;
            data2 = 32'h12345678;
            data3 = 32'h87654321;
            #1;

            check_outputs(32'hCAFECAFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switching select to data3", test_num);
            data0 = 32'h1;
            data1 = 32'h2;
            data2 = 32'h3;
            data3 = 32'h4;
            select = 2'b00;
            #5;
            select = 2'b11;
            #1;

            check_outputs(32'h00000004);
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
        input [31:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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

`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] bus0;
    reg [31:0] bus1;
    reg [31:0] bus2;
    reg [31:0] bus3;
    reg [1:0] sel;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .bus0(bus0),
        .bus1(bus1),
        .bus2(bus2),
        .bus3(bus3),
        .sel(sel),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting bus0", test_num);
            bus0 = 32'hA5A5A5A5;
            bus1 = 32'h00000000;
            bus2 = 32'hFFFFFFFF;
            bus3 = 32'h12345678;
            sel  = 2'b00;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting bus1", test_num);
            bus0 = 32'hA5A5A5A5;
            bus1 = 32'h5A5A5A5A;
            bus2 = 32'h00000000;
            bus3 = 32'hFFFFFFFF;
            sel  = 2'b01;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting bus2", test_num);
            bus0 = 32'h00000000;
            bus1 = 32'h11111111;
            bus2 = 32'h22222222;
            bus3 = 32'h33333333;
            sel  = 2'b10;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting bus3", test_num);
            bus0 = 32'hDEADBEEF;
            bus1 = 32'hCAFEBABE;
            bus2 = 32'h8BADF00D;
            bus3 = 32'hFEEDFACE;
            sel  = 2'b11;
            #1;

            check_outputs(32'hFEEDFACE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Inputs Maximum Value (All 1s)", test_num);
            bus0 = 32'hFFFFFFFF;
            bus1 = 32'hFFFFFFFF;
            bus2 = 32'hFFFFFFFF;
            bus3 = 32'hFFFFFFFF;
            sel  = 2'b10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Check sensitivity - changing non-selected bus", test_num);

            bus0 = 32'h12344321;
            bus1 = 32'h00000000;
            bus2 = 32'h00000000;
            bus3 = 32'h00000000;
            sel  = 2'b00;
            #5;

            bus1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h12344321);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating bit patterns", test_num);
            bus0 = 32'hAAAAAAAA;
            bus1 = 32'h55555555;
            bus2 = 32'h33333333;
            bus3 = 32'hCCCCCCCC;
            sel  = 2'b01;
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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

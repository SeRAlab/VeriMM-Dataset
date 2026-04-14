`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    reg ld;
    reg vz;
    wire lz;
    wire vd;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .ld(ld),
        .vz(vz),
        .lz(lz),
        .vd(vd),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial state - All signals low", test_num);

        d = 8'h00;
        ld = 1'b0;
        vz = 1'b0;


        #1;



        check_outputs(1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load signal active with data", test_num);

        d = 8'h00; ld = 0; vz = 0;
        #5;

        d = 8'hFF;
        ld = 1'b1;
        vz = 1'b0;


        #1;



        check_outputs(1'b0, 1'b1, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Valid-Z (downstream ready) signal active", test_num);

        d = 8'h00; ld = 0; vz = 0;
        #5;

        d = 8'hAA;
        ld = 1'b0;
        vz = 1'b1;


        #1;



        check_outputs(1'b1, 1'b0, 8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Full handshake (Load and Valid-Z both high)", test_num);

        d = 8'h00; ld = 0; vz = 0;
        #5;

        d = 8'h55;
        ld = 1'b1;
        vz = 1'b1;


        #1;



        check_outputs(1'b1, 1'b1, 8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data integrity check with alternating pattern", test_num);

        d = 8'h00; ld = 0; vz = 0;
        #5;

        d = 8'h3C;
        ld = 1'b1;
        vz = 1'b0;

        #1;


        check_outputs(1'b0, 1'b1, 8'h3C);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Check when ld is low but data changes", test_num);

        d = 8'h00; ld = 0; vz = 0;
        #5;

        d = 8'h12;
        ld = 1'b0;
        vz = 1'b1;


        #1;



        check_outputs(1'b1, 1'b0, 8'h12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_lz;
        input expected_vd;
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lz === (expected_lz ^ lz ^ expected_lz) &&
                expected_vd === (expected_vd ^ vd ^ expected_vd) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: lz=%b, vd=%b, z=%h",
                         lz, vd, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lz=%b, vd=%b, z=%h",
                         expected_lz, expected_vd, expected_z);
                $display("  Got:      lz=%b, vd=%b, z=%h",
                         lz, vd, z);
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

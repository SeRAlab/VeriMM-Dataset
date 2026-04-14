`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] bplcon2;
    reg [1:0] nplayfield;
    reg [7:0] nsprite;
    wire sprsel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bplcon2(bplcon2),
        .nplayfield(nplayfield),
        .nsprite(nsprite),
        .sprsel(sprsel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No sprites active", test_num);
        bplcon2 = 6'b000_000;
        nplayfield = 2'b00;
        nsprite = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 0 foreground vs PF1", test_num);
        bplcon2 = 6'b000_000;
        nplayfield = 2'b01;
        nsprite = 8'b00000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 0 background vs PF1", test_num);
        bplcon2 = 6'b000_001;
        nplayfield = 2'b01;
        nsprite = 8'b00000010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 1 foreground vs PF1", test_num);
        bplcon2 = 6'b000_001;
        nplayfield = 2'b01;
        nsprite = 8'b00000100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 1 background vs PF1", test_num);
        bplcon2 = 6'b000_010;
        nplayfield = 2'b01;
        nsprite = 8'b00001000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 2 foreground vs PF2", test_num);
        bplcon2 = 6'b010_000;
        nplayfield = 2'b10;
        nsprite = 8'b00010000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 2 background vs PF2", test_num);
        bplcon2 = 6'b011_000;
        nplayfield = 2'b10;
        nsprite = 8'b00100000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 3 foreground vs PF2", test_num);
        bplcon2 = 6'b011_000;
        nplayfield = 2'b10;
        nsprite = 8'b01000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite 3 background vs PF2", test_num);
        bplcon2 = 6'b100_000;
        nplayfield = 2'b10;
        nsprite = 8'b10000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite Priority (S0 vs S1)", test_num);
        bplcon2 = 6'b000_001;
        nplayfield = 2'b01;
        nsprite = 8'b00000101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sprite Priority (S1 vs S2)", test_num);
        bplcon2 = 6'b000_001;
        nplayfield = 2'b01;
        nsprite = 8'b00010100;
        #1;

        check_outputs(1'b1);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input expected_sprsel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sprsel === (expected_sprsel ^ sprsel ^ expected_sprsel)) begin
                $display("PASS");
                $display("  Outputs: sprsel=%b",
                         sprsel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sprsel=%b",
                         expected_sprsel);
                $display("  Got:      sprsel=%b",
                         sprsel);
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

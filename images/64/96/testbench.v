`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [56:0] In_Tag;
    reg [4:0] Index;
    reg Write;
    reg rst;
    wire hit_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In_Tag(In_Tag),
        .Index(Index),
        .Write(Write),
        .rst(rst),
        .hit_status(hit_status)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Cold Start - Expect Miss", test_num);


        rst = 1;
        Index = 0;
        In_Tag = 0;
        Write = 0;
        #20;
        rst = 0;
        #10;


        Index = 5'd5;
        In_Tag = 57'hA1B2C3D4E5F678;
        Write = 0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Hit", test_num);

        rst = 1; #20; rst = 0; #10;


        Index = 5'd10;
        In_Tag = 57'hFEDCBA987654321;
        Write = 1;
        #20;
        Write = 0;
        #10;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Tag Mismatch - Expect Miss", test_num);

        rst = 1; #20; rst = 0; #10;


        Index = 5'd15;
        In_Tag = 57'hAAAAA_BBBBB_CCCC;
        Write = 1;
        #20;
        Write = 0;
        #10;


        In_Tag = 57'hDDDDD_EEEEE_FFFF;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Index Check (31)", test_num);

        rst = 1; #20; rst = 0; #10;

        Index = 5'd31;
        In_Tag = 57'h1;
        Write = 1;
        #20;
        Write = 0;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite Entry", test_num);

        rst = 1; #20; rst = 0; #10;


        Index = 5'd2;
        In_Tag = 57'h1111111;
        Write = 1; #20;


        In_Tag = 57'h2222222;
        Write = 1; #20;
        Write = 0; #10;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Verification", test_num);

        rst = 1; #20; rst = 0; #10;


        Index = 5'd8;
        In_Tag = 57'hABC;
        Write = 1; #20;
        Write = 0; #10;


        rst = 1; #20; rst = 0; #10;


        Index = 5'd8;
        In_Tag = 57'hABC;
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
        input expected_hit_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hit_status === (expected_hit_status ^ hit_status ^ expected_hit_status)) begin
                $display("PASS");
                $display("  Outputs: hit_status=%b",
                         hit_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hit_status=%b",
                         expected_hit_status);
                $display("  Got:      hit_status=%b",
                         hit_status);
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

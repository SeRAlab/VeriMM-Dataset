`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] rgb565;
    wire [3:0] vga_b;
    wire [3:0] vga_g;
    wire [3:0] vga_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rgb565(rgb565),
        .vga_b(vga_b),
        .vga_g(vga_g),
        .vga_r(vga_r)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros (Black)", test_num);
        rgb565 = 16'h0000;

        #1;


        check_outputs(4'h0, 4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones (White)", test_num);
        rgb565 = 16'hFFFF;

        #1;


        check_outputs(4'hF, 4'hF, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure Red (Max Red, Zero G/B)", test_num);
        rgb565 = 16'hF800;

        #1;


        check_outputs(4'h0, 4'h0, 4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure Green (Max Green, Zero R/B)", test_num);
        rgb565 = 16'h07E0;

        #1;


        check_outputs(4'h0, 4'hF, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure Blue (Max Blue, Zero R/G)", test_num);
        rgb565 = 16'h001F;

        #1;


        check_outputs(4'hF, 4'h0, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bit Pattern A", test_num);
        rgb565 = 16'hAAAA;



        #1;




        check_outputs(4'h5, 4'h5, 4'hA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bit Pattern 5", test_num);
        rgb565 = 16'h5555;



        #1;




        check_outputs(4'hA, 4'hA, 4'h5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid Gray Scale Value", test_num);
        rgb565 = 16'h8410;



        #1;




        check_outputs(4'h8, 4'h8, 4'h8);
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
        input [3:0] expected_vga_b;
        input [3:0] expected_vga_g;
        input [3:0] expected_vga_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vga_b === (expected_vga_b ^ vga_b ^ expected_vga_b) &&
                expected_vga_g === (expected_vga_g ^ vga_g ^ expected_vga_g) &&
                expected_vga_r === (expected_vga_r ^ vga_r ^ expected_vga_r)) begin
                $display("PASS");
                $display("  Outputs: vga_b=%h, vga_g=%h, vga_r=%h",
                         vga_b, vga_g, vga_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vga_b=%h, vga_g=%h, vga_r=%h",
                         expected_vga_b, expected_vga_g, expected_vga_r);
                $display("  Got:      vga_b=%h, vga_g=%h, vga_r=%h",
                         vga_b, vga_g, vga_r);
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

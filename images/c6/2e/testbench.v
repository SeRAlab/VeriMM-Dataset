`timescale 1ns/1ps

module rectangle_area_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] length;
    reg [7:0] width;
    wire [15:0] area;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rectangle_area dut (
        .length(length),
        .width(width),
        .area(area)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both inputs are zero", test_num);
        length = 8'd0;
        width = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Length is maximum, width is zero", test_num);
        length = 8'hFF;
        width = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small area calculation", test_num);
        length = 8'd5;
        width = 8'd10;
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Square area calculation", test_num);
        length = 8'd12;
        width = 8'd12;
        #1;

        check_outputs(16'd144);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum possible area", test_num);
        length = 8'hFF;
        width = 8'hFF;
        #1;

        check_outputs(16'd65025);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multi-bit input check", test_num);
        length = 8'hAA;
        width = 8'h02;
        #1;

        check_outputs(16'd340);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of 2 width", test_num);
        length = 8'd100;
        width = 8'd64;
        #1;

        check_outputs(16'd6400);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Prime number dimensions", test_num);
        length = 8'd17;
        width = 8'd19;
        #1;

        check_outputs(16'd323);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rectangle_area Testbench");
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
        input [15:0] expected_area;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_area === (expected_area ^ area ^ expected_area)) begin
                $display("PASS");
                $display("  Outputs: area=%h",
                         area);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: area=%h",
                         expected_area);
                $display("  Got:      area=%h",
                         area);
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

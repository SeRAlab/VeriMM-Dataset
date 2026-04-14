`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [1:0] x;
    reg [1:0] y;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .x(x),
        .y(y),
        .pixel_out(pixel_out)
    );
    task testcase001;

    begin
        test_num = 1;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd0; y = 2'd0;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd1; y = 2'd0;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd2; y = 2'd0;
        #1;

        check_outputs(8'h0B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd3; y = 2'd0;
        #1;

        check_outputs(8'h0B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd0; y = 2'd1;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd1; y = 2'd1;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd2; y = 2'd1;
        #1;

        check_outputs(8'h0B);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd3; y = 2'd1;
        #1;

        check_outputs(8'h0B);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd0; y = 2'd2;
        #1;

        check_outputs(8'h0C);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd1; y = 2'd2;
        #1;

        check_outputs(8'h0C);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd2; y = 2'd2;
        #1;

        check_outputs(8'h0D);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd3; y = 2'd2;
        #1;

        check_outputs(8'h0D);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd0; y = 2'd3;
        #1;

        check_outputs(8'h0C);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd1; y = 2'd3;
        #1;

        check_outputs(8'h0C);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd2; y = 2'd3;
        #1;

        check_outputs(8'h0D);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        pixel00 = 8'h0A; pixel01 = 8'h0B; pixel10 = 8'h0C; pixel11 = 8'h0D;
        x = 2'd3; y = 2'd3;
        #1;

        check_outputs(8'h0D);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
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
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [7:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%h",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%h",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%h",
                         pixel_out);
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

`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg start;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] y1;
    reg [31:0] y2;
    wire done;
    wire [31:0] x3;
    wire [31:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .start(start),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .done(done),
        .x3(x3),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            x1 = 0;
            y1 = 0;
            x2 = 0;
            y2 = 0;
            repeat(2) @(posedge start);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Point Addition (P1 != P2)");

            x1 = 32'h00000005;
            y1 = 32'h00000001;
            x2 = 32'h00000009;
            y2 = 32'h00000010;


            wait(done == 1);
            @(posedge start);



            #1;




            check_outputs(1'b1, 32'h000000AF, 32'h000000BC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Point Doubling (P1 == P2)");
            x1 = 32'h00000005;
            y1 = 32'h00000001;
            x2 = 32'h00000005;
            y2 = 32'h00000001;

            wait(done == 1);
            @(posedge start);


            #1;



            check_outputs(1'b1, 32'h000000FF, 32'h000000EE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Large Coordinate Addition");
            x1 = 32'hFFFF0001;
            y1 = 32'hAAAA0002;
            x2 = 32'h12345678;
            y2 = 32'h87654321;

            wait(done == 1);
            @(posedge start);

            #1;


            check_outputs(1'b1, 32'h5555AAAA, 32'h11112222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_point_addition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input expected_done;
        input [31:0] expected_x3;
        input [31:0] expected_y3;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: done=%b, x3=%h, y3=%h",
                         done, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, x3=%h, y3=%h",
                         expected_done, expected_x3, expected_y3);
                $display("  Got:      done=%b, x3=%h, y3=%h",
                         done, x3, y3);
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
        $dumpvars(0,start, x1, x2, y1, y2, done, x3, y3);
    end

endmodule

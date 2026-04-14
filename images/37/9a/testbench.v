`timescale 1ns/1ps

module morphological_erosion_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] binary_image;
    reg [8:0] struct_elem;
    wire [8:0] eroded_image;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_erosion dut (
        .binary_image(binary_image),
        .struct_elem(struct_elem),
        .eroded_image(eroded_image)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All ones image and structuring element", test_num);
            binary_image = 25'h1FFFFFF;
            struct_elem = 9'h1FF;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All zeros image", test_num);
            binary_image = 25'h0;
            struct_elem = 9'h1FF;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Identity Structuring Element (center bit only)", test_num);






            binary_image = 25'h1555555;
            struct_elem = 9'h010;



            #1;




            check_outputs(9'h155);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Image with missing center pixel", test_num);
            binary_image = 25'h1FFFFFF ^ (25'h1 << 12);
            struct_elem = 9'h1FF;


            #1;



            check_outputs(9'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Single 3x3 block in top-left", test_num);





            binary_image = 25'b11100_11100_11100_00000_00000;
            struct_elem = 9'h1FF;

            #1;


            check_outputs(9'h100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Horizontal line detection", test_num);

            binary_image = 25'b00000_00000_11111_00000_00000;

            struct_elem = 9'b000_111_000;


            #1;



            check_outputs(9'h038);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Vertical line detection", test_num);

            binary_image = 25'b00100_00100_00100_00100_00100;

            struct_elem = 9'b010_010_010;

            #1;


            check_outputs(9'h092);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Empty Structuring Element (Vacuous Truth)", test_num);
            binary_image = 25'h0;
            struct_elem = 9'h000;

            #1;


            check_outputs(9'h1FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("morphological_erosion Testbench");
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
        input [8:0] expected_eroded_image;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eroded_image === (expected_eroded_image ^ eroded_image ^ expected_eroded_image)) begin
                $display("PASS");
                $display("  Outputs: eroded_image=%h",
                         eroded_image);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eroded_image=%h",
                         expected_eroded_image);
                $display("  Got:      eroded_image=%h",
                         eroded_image);
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
